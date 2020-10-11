;; to consider: all-the-icons.el

;; Allow lots of garbage during startup, then go back to normal afterwards.
(setq gc-cons-threshold 64000000)
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))

;; Setup straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Colors and fonts
(straight-use-package 'gruvbox-theme)
(load-theme 'gruvbox-dark-hard t)
(add-to-list 'default-frame-alist '(font . "CaskaydiaCove Nerd Font Mono 12"))

;; Ligatures.
;; No MELPA support yet: https://github.com/mickeynp/ligature.el
(load-file "~/.emacs.d/local/ligature.el")
(ligature-set-ligatures 't '("www"))
(ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))

(global-ligature-mode 't)

;; Magit and vc configuration
(straight-use-package 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(setq vc-follow-symlinks t)
(straight-use-package 'git-timemachine)
(straight-use-package 'gitignore-mode)
(straight-use-package 'gitconfig-mode)
(straight-use-package 'gitattributes-mode)

;; git-gutter
(straight-use-package 'git-gutter)
(global-git-gutter-mode +1)

(custom-set-variables
 '(git-gutter:window-width 2)
 '(git-gutter:added-sign "+")
 '(git-gutter:modified-sign "=")
 '(git-gutter:deleted-sign "-")
 '(git-gutter:update-interval 1))

(dolist (face '(git-gutter:added git-gutter:modified git-gutter:deleted	git-gutter:unchanged))
  (set-face-background face "background"))

(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

; Powerline
(straight-use-package 'powerline)
(powerline-center-theme)

;; Projectile
(straight-use-package 'projectile)
(projectile-mode +1)
(setq projectile-completion-system 'ivy)
(global-set-key "\C-xf" 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Compilation
(straight-use-package 'meson-mode)

;; Snippets
(setq yas-snippet-dirs '("~/dotfiles-home/emacs/snippets"))
(straight-use-package 'yasnippet)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(defun yas-c-mode-common-hook ()
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode))

(add-hook 'c-mode-common-hook 'yas-c-mode-common-hook)

;; Ivy/Counsel/Swiper
(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'counsel-projectile)
(straight-use-package 'swiper)

(ivy-mode)
(counsel-mode)
(counsel-projectile-mode)
(global-set-key (kbd "C-s") 'swiper)
(setq ivy-re-builders-alist
      '((t . ivy--regex-fuzzy)))

;; Disable useless things.
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(setq scroll-preserve-screen-position 'always)

(straight-use-package 'goto-last-change)
(global-set-key (kbd "C-x C-\\") 'goto-last-change)

;; Don't show the startup screen and show only minimal text in the scratch buffer.
(setq inhibit-startup-screen t
      initial-scratch-message ";; ready\n\n")

;; Make the window divider nicer looking.
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

;; Miscellaneous packages
(straight-use-package 'amx)
(straight-use-package 'ripgrep)
(straight-use-package 'deadgrep)
(straight-use-package 'web-mode)
(straight-use-package 'fish-mode)

;; Haskell
(straight-use-package 'haskell-mode)
(straight-use-package 'ghc)

;; Backup and auto-save configuration.
(let ((backup-dir "~/.emacs.d/backup")
      (auto-saves-dir "~/.emacs.d/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too

;; Modes
(straight-use-package 'blackout)
(blackout 'counsel-mode)
(blackout 'ivy-mode)
(blackout 'projectile-mode "🚀")
(blackout 'git-gutter-mode "🔃")
(blackout 'eldoc-mode "📖")

; Setup C++ indentation like I like it.
(setq-default indent-tabs-mode nil)

; Added in 2008.
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
  (show-paren-mode t)
  (setq truncate-lines nil)
  (setq fill-column 120)
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; Treat .h and .ipp files as C++.
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ipp$" . c++-mode))

;; Smart clang formatting
(straight-use-package 'clang-format)

(defun clang-format-buffer-smart ()
  (interactive)
  "Reformat buffer if .clang-format exists in the projectile root."
  (when (file-exists-p (expand-file-name ".clang-format" (projectile-project-root)))
    (clang-format-buffer)))

(add-hook 'c-mode-common-hook
	  (function (lambda ()
		      (add-hook 'before-save-hook
				'clang-format-buffer-smart))))

;; Meson project support for projectile
(projectile-register-project-type 'meson '("meson.build")
                                  :project-file "meson.build"
                                  :compile "cd builddir && ninja"
                                  :test "cd builddir && ninja test")

;; Don't prompt for compilation command.
(setq compilation-read-command nil)

;; Miscellanous key bindings
(global-set-key (kbd "C-c M-r") 'revert-buffer)
