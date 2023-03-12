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

(defvar +zen-text-scale 1.5)
(defvar +zen-window-divider-size 4)
(defvar +zen--old-window-divider-size nil)

(after! writeroom-mode
  (defvar +zen--old-writeroom-global-effects writeroom-global-effects)
  (setq writeroom-global-effects nil)
  (setq writeroom-maximize-window nil)

  (add-hook! 'writeroom-mode-hook :append
    (defun +zen-enable-text-scaling-mode-h ()
      (when (/= +zen-text-scale 0)
        (text-scale-set (if writeroom-mode +zen-text-scale 0))
        (visual-fill-column-adjust))))

  (add-hook! 'global-writeroom-mode-hook
    (defun +zen-toggle-large-window-dividers-h ()
      "Make window dividers larger and easier to see."
      (when (bound-and-true-p window-divider-mode)
        (if writeroom-mode
            (setq +zen--old-window-divider-size
                  (cons window-divider-default-bottom-width
                        window-divider-default-right-width)
                  window-divider-default-bottom-width +zen-window-divider-size
                  window-divider-default-right-width +zen-window-divider-size)
          (when +zen--old-window-divider-size
            (setq window-divider-default-bottom-width (car +zen--old-window-divider-size)
                  window-divider-default-right-width (cdr +zen--old-window-divider-size))))
        (window-divider-mode +1))))
  (advice-add #'text-scale-adjust :after #'visual-fill-column-adjust))

(map! :leader
      :desc "Toggle Zen Mode"
      "t z" #'writeroom-mode)

(setq org-directory "~/org/")
(setq org-hide-emphasis-markers t)

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

(setq org-roam-directory "~/notes")

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package org-roam
  :bind (
         ("C-c n I" . org-roam-node-insert-immediate)
         ))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))
