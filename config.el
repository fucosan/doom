;;; $DOOMDIR/config.el -*- lexical-binding: -

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Kamal"
      user-mail-address "john@doe.com")

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
(setq doom-font (font-spec :family "GeistMono Nerd Font" :size 20 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 15))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/personal/org/")
(after! org
  (setq org-agenda-files '("~/Documents/personal/org/roam/daily"))
  )

(defun load-roam-dir ()
  (interactive)
  (setq org-agenda-files '("~/Documents/personal/org/roam/daily"))
  )

;; (setq org-roam-dailies-directory "~/Documents/personal/org/journals")
;; (use-package! org-journal
;;   ;; :bind
;;   ;; ("C-c n j" . org-journal-new-entry)
;;   :custom
;;   (org-journal-date-prefix "#+title: ")
;;   (org-journal-file-format "%Y-%m-%d.org")
;;   (org-journal-dir "/home/kamal/Documents/personal/org/roam/daily/")
;;   (org-journal-date-format "%A, %d %B %Y"))


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

(map! :leader "2" #'next-buffer)
(map! :leader "1" #'previous-buffer)
(map! :leader "3" #'evil-switch-to-windows-last-buffer)
(map! :leader "4" #'dired-jump)
;;(map! :leader "j" #'avy-goto-char-timer)
(map! :leader "cl" #'org-cycle-list-bullet)
(map! :leader "`" #'+workspace/cycle)
(map! :leader ";" #'execute-extended-command)                         ;
(map! :leader ":" #'eval-expression)
(map! :leader "w;" #'delete-other-windows)
(map! :leader "y" #'avy-copy-region)
(map! :leader "oo" #'async-shell-command)
(map! :leader "oi" #'projectile-run-async-shell-command-in-root)
(map! :leader "[" #'org-roam-node-find)

(define-key evil-normal-state-map (kbd "C-;") 'evil-multiedit-match-all)
(define-key evil-normal-state-map (kbd "go") #'avy-goto-char-timer)
(setq-default truncate-lines nil)


(after! projectile
  (setq projectile-project-search-path '("~/project/"))
  )

(add-hook 'vue-mode-hook #'lsp!)
(use-package! kubernetes
  :ensure t
  :commands (kubernetes-overview)
  :config
  (setq kubernetes-poll-frequency 3600
        kubernetes-redraw-frequency 3600))

(use-package! lsp-tailwindcss)


(global-display-fill-column-indicator-mode)

(setq avy-all-windows 'all-frames)
;;(setq avy-timeout-seconds 0.3)

(defun run-vterm ()
  (interactive)
  (toggle-frame-fullscreen)
  (vterm)
  (delete-other-windows)
  )

(defun wifi-available ()
  (interactive)
  (async-shell-command "nmcli device wifi list"))

(defun wifi-connect (name)
  "Connect to a Wi-Fi network using nmcli."
  (interactive "sEnter the Wi-Fi network name: ")
  (if (zerop (shell-command (concat "nmcli connection up " (shell-quote-argument name))))
      (message "Connected to %s" name)
    (message "Failed to connect to %s" name)))

(defun wifi-status ()
  (interactive)
  (shell-command "nmcli -g GENERAL.CONNECTION device show")
  )


(defun cp-py (name)
  "competitive programming compile and run python"
  (interactive "sEnter the filename: ")
  (if (zerop (async-shell-command (concat "python3 a.py < in" (shell-quote-argument name))))
      (message "compiled %s" name)
    (message "Failed to compiled  %s" name)))

(defun cp-c++ (name)
  "competitive programing compile and run c++"
  (interactive "sEnter the filename: ")
  (if (zerop (async-shell-command (concat "g++ -o a a.cpp && ./a < in" (shell-quote-argument name))))
      (message "compiled %s" name)
    (message "Failed to compiled  %s" name)))

(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))
