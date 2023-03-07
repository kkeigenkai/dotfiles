;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Sergei Pshonnov"
      user-mail-address "sergei@pshonnov.ru")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "Iosevka Custom" :size 14)
      doom-big-font (font-spec :family "Iosevka Custom" :size 24))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defun go-hook ()
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

(add-hook 'go-mode-hook 'go-hook)

(setq lsp-log-io nil)


;; (use-package! mixed-pitch
;;   :hook (writeroom-mode . doom-big-font)
;;   :config
;;   (defun +zen-enable-mixed-pitch-mode-h ()
;;     "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
;;     (when (apply #'derived-mode-p doom-big-font)
;;       (mixed-pitch-mode (if writeroom-mode +1 -1))))
;;   )
;;   

(defvar +zen-text-scale 2
  "The text-scaling level for `writeroom-mode'.")

(defvar +zen-window-divider-size 4
  "Pixel size of window dividers when `writeroom-mode' is active.")

(defvar +zen--old-window-divider-size nil)


;;
;;; Packages

(after! writeroom-mode
  ;; Users should be able to activate writeroom-mode in one buffer (e.g. an org
  ;; buffer) and code in another. No global behavior should be applied.
  ;; Fullscreening/maximizing will be opt-in.
  (defvar +zen--old-writeroom-global-effects writeroom-global-effects)
  (setq writeroom-global-effects nil)
  (setq writeroom-maximize-window nil)

  (add-hook! 'writeroom-mode-hook :append
    (defun +zen-enable-text-scaling-mode-h ()
      "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
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

  ;; Adjust margins when text size is changed
  (advice-add #'text-scale-adjust :after #'visual-fill-column-adjust))

(map! :leader
      :desc "Toggle Zen Mode"
      "t z" #'writeroom-mode)

(setq org-roam-directory "~/notes")
(setq org-hide-emphasis-markers t)
