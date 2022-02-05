;; Define and initialize package repositories.
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org"   . "https://orgmode.org/elpa/")
			 ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure 't)

;; Keep customize configurations out of my init file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Don't make backup~ files.
(setq make-backup-files nil)

;; Minimal decorations.
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Color theming and font.
(use-package gruvbox-theme
  :config (load-theme 'gruvbox t))

(set-face-attribute 'default nil :font "CaskaydiaCove Nerd Font" :height 120)

;; Ask for y/n instead of yes/no.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Better M-x.
(use-package amx :config (amx-mode))

;; Various simple packages.
(use-package magit)
(use-package markdown-mode)
(use-package rg)
(use-package cmake-mode)
(use-package deadgrep)

;; Smart mode line
(use-package smart-mode-line
  :config
  (setq sml/theme 'dark)
  (sml/setup)
  )

(global-display-line-numbers-mode)

;; Which key
(use-package which-key
  :config
  (setq which-key-idle-delay 0.5) ;; seconds
  (which-key-mode))

;; anzu (display current match/total matches in various search modes)
(use-package anzu)
(global-anzu-mode +1)

;; Projectile.
(use-package projectile
  :config (projectile-mode +1)
  :bind (("C-x f" . projectile-find-file))
  :bind-keymap ("C-c p" . projectile-command-map)
  :init (setq projectile-enable-caching t))

;; Selectrum, Prescient, and Consult.
(use-package selectrum :config (selectrum-mode +1))
(use-package prescient :config (prescient-persist-mode +1))
(use-package selectrum-prescient :init (selectrum-prescient-mode +1) :after selectrum)
(use-package consult
  :bind (("C-x r x" . consult-register)
         ("C-x r b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complet-command
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ("M-g o" . consult-outline)
         ("M-g h" . consult-org-heading)
         ("M-g a" . consult-org-agenda)
         ("M-g m" . consult-mark)
         ("C-x b" . consult-buffer)
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-project-imenu)
         ("M-g e" . consult-error)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s L" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         ("M-g l" . consult-line)
         ("M-s m" . consult-multi-occur)
         ("C-x c o" . consult-multi-occur)
         ("C-x c SPC" . consult-mark)
         :map isearch-mode-map
         ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch)               ;; orig. isearch-edit-string
         ("M-s l" . consult-line)))

(use-package marginalia
  :bind (("M-A" . marginalia-cycle)
	 :map minibuffer-local-map
	 ("M-A" . marginalia-cycle))
  :init (marginalia-mode))
