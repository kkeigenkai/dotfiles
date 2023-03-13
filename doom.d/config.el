;;; ~/.dotfiles/doom.d/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Sergei Pshonnov"
      user-mail-address "sergei@pshonnov.ru")

(setq doom-font (font-spec :family "Iosevka Custom" :size 14)
      doom-big-font (font-spec :family "Iosevka Custom" :size 24))
(setq doom-theme 'doom-one)
(setq display-line-numbers-type nil)
(setq initial-frame-alist '((left . 27) (top . 54) (width . 205) (height . 49)))
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)

(setq lsp-log-io nil)

(defun go-hook ()
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

(add-hook 'go-mode-hook 'go-hook)

(defvar +zen-text-scale 1)
(defvar +zen-window-divider-size 4)
(defvar +zen--old-window-divider-size nil)

(after! writeroom-mode
  (defvar +zen--old-writeroom-global-effects writeroom-global-effects)
  (setq writeroom-global-effects nil)
  (setq writeroom-maximize-window nil)
  (setq writeroom-width 0.6)

  (add-hook! 'writeroom-mode-hook :append
    (defun +zen-enable-text-scaling-mode-h ()
      (when (/= +zen-text-scale 0)
        (text-scale-set (if writeroom-mode +zen-text-scale 0))
        (visual-fill-column-adjust))))

  (advice-add #'text-scale-adjust :after #'visual-fill-column-adjust))

(map! :leader
      :desc "Toggle Zen Mode"
      "t z" #'writeroom-mode)

(setq org-directory "~/org/")
(setq org-hide-emphasis-markers t)

(use-package org-roam
  :ensure t
  :demand t
  :init
  (setq org-roam-v2-ack t)
  :bind (
         ("C-c n I" . #'org-roam-node-insert-immediate)
         ("C-c n p" . #'my/org-roam-find-project)
         ("C-c n b" . #'my/org-roam-capture-inbox)
         ("C-c n t" . #'my/org-roam-capture-task))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :custom
  (org-roam-directory "~/notes")
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("l" "programming language" plain
      "* Characteristic:\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("p" "project" plain
      (file "~/notes/.templates/ProjectTemplate.org")
      :if-new (file "%<%Y%m%d%H%M%S>-${slug}.org")
      :unnarrowed t)))
  :config
  (require 'org-roam-dailies)
  (org-roam-db-autosync-mode))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun my/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
          (seq-filter
           (my/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))

(defun my/org-roam-refresh-agenda-list ()
  (interactive)
  (setq org-agenda-files (my/org-roam-list-notes-by-tag "Project")))

(my/org-roam-refresh-agenda-list)

(defun my/org-roam-project-finalize-hook ()
  (remove-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)
  (unless org-note-abort
    (with-current-buffer (org-capture-get :buffer)
      (add-to-list 'org-agenda-files (buffer-file-name)))))

(defun my/org-roam-find-project ()
  (interactive)
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)
  (org-roam-node-find
   nil
   nil
   (my/org-roam-filter-by-tag "Project")
   nil
   :templates
   '(("p" "project" plain
      (file "~/notes/.templates/ProjectTemplate.org")
      :if-new (file "%<%Y%m%d%H%M%S>-${slug}.org")
      :unnarrowed t))))

(setq org-roam-dailies-directory "daily/")

(defun my/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "\n* %?"
                                   :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

(defun my/org-roam-capture-task ()
  (interactive)
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)
  (org-roam-capture- :node (org-roam-node-read
                            nil
                            (my/org-roam-filter-by-tag "Project"))
                     :templates '(("p" "project" plain "** TODO %?"
                                   :if-new
                                   (file+head+olp
                                    "%<%Y%m%d%H%M%S>-${slug}.org"
                                    "#+title: ${title}\n#+category: ${title}\n#+filetags: Project"
                                    ("Tasks"))))))

(defun my/org-roam-copy-todo-to-today ()
  (interactive)
  (let ((org-refile-keep t) ;; Set this to nil to delete the original!
        (org-roam-dailies-capture-templates
         '(("t" "tasks" entry "%?"
            :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
        (org-after-refile-insert-hook #'save-buffer)
        today-file
        pos)
    (save-window-excursion
      (org-roam-dailies--capture (current-time) t)
      (setq today-file (buffer-file-name))
      (setq pos (point)))

    ;; Only refile if the target file is different than the current file
    (unless (equal (file-truename today-file)
                   (file-truename (buffer-file-name)))
      (org-refile nil nil (list "Tasks" today-file nil pos)))))

(add-to-list 'org-after-todo-state-change-hook
             (lambda ()
               (when (equal org-state "DONE")
                 (my/org-roam-copy-todo-to-today))))

(use-package! org-modern
  :after (org org-agenda org-roam)
  :init
  (global-org-modern-mode))

(setq org-auto-align-tags nil
      org-tags-column 0
      org-fold-catch-invisible-edits 'show-and-error
      org-special-ctrl-a/e t
      org-insert-heading-respect-content t

      org-hide-emphasis-markers t
      org-pretty-entities t
      org-ellipsis "…"

      org-agenda-tags-column 0
      org-agenda-block-separator ?─
      org-agenda-time-grid
      '((daily today require-timed)
        (800 1000 1200 1400 1600 1800 2000)
        " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
      org-agenda-current-time-string
      "⭠ now ─────────────────────────────────────────────────"

      org-modern-list '((43 . "➤")
                        (45 . "–")
                        (42 . "•"))

      org-modern-block-name
      '((t . t)
        ("src" "»" "«")
        ("example" "»–" "–«")
        ("quote" "❝" "❞")))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))
