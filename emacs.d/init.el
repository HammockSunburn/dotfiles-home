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

(custom-set-variables
 '(gnutls-algorithm-priority "normal:-vers-tls1.3"))

;; Keep customize configurations out of my init file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Don't make backup~ files.
(setq make-backup-files nil)

;; Human readable file sizes in dired.
(setq dired-listing-switches "-alFh")

;; Minimal decorations.
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Color theming and font.
;; Other good ones: darktooth-theme, ample-theme, modus-vivendi, ef-themes.
(use-package ef-themes
  :config (load-theme 'ef-autumn t))

(set-face-attribute 'default nil :font "Cascadia Code PL" :height 120)

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
(use-package meson-mode)
(use-package rmsbolt)

;; Hydra for git-gutter actions.
(use-package hydra
  :config
  (defhydra hydra-git (global-map "<f6>")
    "Git Hydra"
    ("]" git-gutter:next-hunk "next" :column "Navigation")
    ("[" git-gutter:previous-hunk "previous" :column "Navigation")
    ("k" git-gutter:revert-hunk "revert" :column "Commands")
    ("m" git-gutter:mark-hunk "mark" :column "Commands")
    ("s" git-gutter:stage-hunk "stage" :column "Commands")))

;; Haskell
(use-package haskell-mode)

;; Org mode
(use-package ob-async)

(org-babel-do-load-languages
 'org-babel-load-languages '(
			     (C . t)
			     (shell . t)))

;; All org files are here
(setq org-agenda-files (list "~/dotfiles-home/org"))

;; Default notes file for captures
(setq org-default-notes-file "~/dotfiles-home/org/notes.org")

;; Refile anywhere
(setq org-refile-targets '((nil :maxlevel . 9)
                                (org-agenda-files :maxlevel . 9)))

;; Refile in a single go
(setq org-outline-path-complete-in-steps nil)

;; Show full paths for refiling
(setq org-refile-use-outline-path t)

;; Ace window switching.
(use-package ace-window
  :bind (("M-o" . ace-window)))

;; Beacon point highlighting.
(use-package beacon
  :config
  (beacon-mode 1)
  (setq beacon-blink-when-window-scrolls 't)
  (setq beacon-blink-when-window-changes 't))

;; devdocs browsing.
;; Use devdocs-install and devdocs-update-all
(use-package devdocs
  :config
  (add-hook 'c++-mode-hook (lambda () (setq-local devdocs-current-docs '("cpp"))))
  (add-hook 'cmake-mode-hook (lambda () (setq-local devdocs-current-docs '("cmake~3.21"))))
  :bind (("C-h D" . devdocs-lookup)))

;; Other git setup
(use-package git-gutter
  :demand
  :config (global-git-gutter-mode +1))

;; AUCTeX
(use-package tex :ensure auctex)

;; clang-format
(use-package clang-format
  :after cc-mode
  :bind (:map c-mode-base-map
	      ("S-<f12>" . clang-format-buffer)
	      ("<f12>" . clang-format-region)))

(if (string= (getenv "HOME") "/home/esc")
    (progn
      (defun my-c-mode-common-hook ()
	(define-key c-mode-base-map "\C-m" 'newline-and-indent)
	(c-set-offset 'substatement-open 0)
	(c-set-offset 'arglist-intro 8)
	(c-set-offset 'arglist-close 4)
	(c-set-offset 'case-label 0)
	(c-set-offset 'inclass 4)
	(c-set-offset 'comment-intro 0)
	(c-set-offset 'topmost-intro-cont 0)
	(c-set-offset 'innamespace 0)
	(c-set-offset 'namespace-open 0)
	(c-set-offset 'namespace-close 0)
	(c-set-offset 'template-args-cont 4)
	(c-set-offset 'statement-case-open 0)
	(c-set-offset 'statement-case-intro 4)
	(c-set-offset 'member-init-intro 4)
	(c-set-offset 'member-init-cont -2)
	(c-set-offset 'inher-cont 0)
	(c-set-offset 'statement-cont 4)
	(c-set-offset 'brace-list-open 0)
	(c-set-offset 'brace-list-intro 4)
	(c-set-offset 'statement-case-open 0)
	(c-set-offset 'statement-block-intro 4)
	(c-set-offset 'defun-block-intro 4)
	(c-set-offset 'case-label 4)
	(c-set-offset 'access-label -4)
	(setq truncate-lines nil)
	(setq fill-column 120))

      (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)))

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

;; Color compilation buffers.
(ignore-errors
  (use-package ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))

;; Projectile.
(use-package projectile
  :config (projectile-mode +1)
  :bind (
	 ("C-x f" . projectile-find-file)
	 ("<f5>" . projectile-compile-project)
	 )
  :bind-keymap ("C-c p" . projectile-command-map)
  :init (setq projectile-enable-caching t))

;; Vertico, Prescient, and Consult.
(use-package vertico :init (vertico-mode))
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
