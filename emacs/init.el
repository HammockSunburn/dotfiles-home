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

;; Find the horizontal pixels per millimeter on the selected frame.
(defun hs:x-pitch ()
  (let* ((monitor-attr (frame-monitor-attributes (selected-frame)))
         (x-pixels (nth 3 (assoc 'geometry monitor-attr)))
         (x-mm (nth 1 (assoc 'mm-size monitor-attr))))
    (/ (float x-pixels) (float x-mm))))

;; Choose a font based on the horizontal pixels per millimeter.
(defun hs:get-font ()
  (format "CaskaydiaCove Nerd Font Mono-%d"
          (if (> (hs:x-pitch) 3.5)
              18
            12)))

(add-to-list 'default-frame-alist (cons 'font (hs:get-font)))

;; Ligatures.
;; No MELPA support yet: https://github.com/mickeynp/ligature.el
;;(load-file "~/.emacs.d/local/ligature.el")
;;(ligature-set-ligatures 't '("www"))
;;(ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
;;                                     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
;;                                     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
;;                                     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
;;                                     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
;;                                     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
;;                                     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
;;                                     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
;;                                     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
;;                                     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
;;
;;(global-ligature-mode 't)

;; Although it's for Fira Code, see:
;; https://github.https://github.com/tonsky/FiraCode/wiki/Emacs-instructions
;;(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
;;               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
;;               (36 . ".\\(?:>\\)")
;;               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
;;               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
;;               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
;;               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
;;               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
;;               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
;;               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
;;               (48 . ".\\(?:x[a-zA-Z]\\)")
;;               (58 . ".\\(?:::\\|[:=]\\)")
;;               (59 . ".\\(?:;;\\|;\\)")
;;               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
;;               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
;;               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
;;               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
;;               (91 . ".\\(?:]\\)")
;;               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
;;               (94 . ".\\(?:=\\)")
;;               (119 . ".\\(?:ww\\)")
;;               (123 . ".\\(?:-\\)")
;;               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
;;               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
;;               )
;;             ))
;;  (dolist (char-regexp alist)
;;    (set-char-table-range composition-function-table (car char-regexp)
;;                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

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
(setq git-gutter:added-sign "+"
      git-gutter:deleted-sign "-"
      git-gutter:modified-sign "="
      git-gutter:update-interval 1
      git-gutter:window-width 2)

(dolist (face '(git-gutter:added git-gutter:modified git-gutter:deleted	git-gutter:unchanged))
  (set-face-background face "background"))

(global-set-key (kbd "C-x P") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x N") 'git-gutter:next-hunk)
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

;; Spaceline
(straight-use-package 'spaceline)
(spaceline-spacemacs-theme)

;; Projectile
(straight-use-package 'projectile)
(projectile-mode +1)
(setq projectile-completion-system 'ivy)
(global-set-key "\C-xf" 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-enable-caching t)

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

;; Ivy regular expression builders
(setq ivy-re-builders-alist
      '((ivy-switch-buffer . ivy--regex-plus)
        (counsel-projectile-find-file . ivy--regex-plus)
        (swiper . ivy--regex-plus)
        (t . ivy--regex-plus)))

;; Make counsel-find-file minibuffer window 1/3 the height of the frame.
(add-to-list 'ivy-height-alist
             (cons 'counsel-find-file
                   (lambda (_caller)
                     (/ (frame-height) 3))))

;; Make swiper minibuffer window 1/3 the height of the frame, too.
(add-to-list 'ivy-height-alist
             (cons 'swiper
                   (lambda (_caller)
                     (/ (frame-height) 3))))

;; Make counsel-rg even larger at 1/2 the height of the frame.
(add-to-list 'ivy-height-alist
             (cons 'counsel-rg
                   (lambda (_caller)
                     (/ (frame-height) 2))))


;; Disable useless things.
(menu-bar-mode -1)
(tool-bar-mode -1)
(when (display-graphic-p)
  (toggle-scroll-bar -1))

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

;; Markdown
(straight-use-package 'markdown-mode)

;; Ace-window
(straight-use-package 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)

;; Haskell
(straight-use-package 'haskell-mode)
(straight-use-package 'ghc)

;; EMMS
(straight-use-package 'emms)
(emms-all)
(emms-default-players)
(setq emms-source-file-default-directory "~/Music/")

;; Org mode configuration
(add-hook 'org-load-hook
          (lambda ()
            (define-key org-mode-map "\M-n" 'org-next-link)
            (define-key org-mode-map "\M-p" 'org-previous-link)))

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

;; which-key configuration
(straight-use-package 'which-key)
(setq which-key-idle-delay 0.5) ;; 500 ms
(setq which-key-idle-secondary-delay 0.05) ;; instantaneous
(which-key-mode)

;; Miscellanous key bindings.
(global-set-key (kbd "C-c M-r") 'revert-buffer)

;; Calc mode
;; The default key is M-tab which is already taken by Gnome.
(add-hook 'calc-mode-hook
          (function (lambda ()
                      (local-set-key (kbd "<backtab>") 'calc-roll-up))))

;; My dired customizations.
;; Rename selected dired files to start with the EXIF CreateDate field.
(defun hs:rename-with-exif-date ()
  (interactive)
  (dolist (elt (dired-get-marked-files))
    (when (and
           (not (string-match "^[[:digit:]]\\{8\\}" (file-name-nondirectory elt)))
           (file-regular-p elt))
      (dired-do-shell-command "exiftool '-FileName<CreateDate' -d %Y%m%d-%%f.%%e `?`" 0 (list elt))))
  (revert-buffer))

;; Convert HEIC files into jpg
(defun hs:convert-heic ()
  (interactive)
  (dolist (elt (dired-get-marked-files))
    (when (and
           (string-match "\\.\\(HEIC\\|heic\\)$" (file-name-nondirectory elt))
           (file-regular-p elt))
      (dired-do-shell-command "heif-convert `?` `?`.jpg" 0 (list elt))))
  (revert-buffer))

(defun hs:dired-mode-keys ()
  (progn
    (local-set-key (kbd "C-c X") 'hs:rename-with-exif-date)
    (local-set-key (kbd "C-c C") 'hs:convert-heic)))

(add-hook 'dired-mode-hook 'hs:dired-mode-keys)

(defun counsel-bookmark-other-window ()
  "Forward to `bookmark-jump-other-window' or `bookmark-set' if bookmark doesn't exist."
  (interactive)
  (require 'bookmark)
  (ivy-read "Create or jump to bookmark in other window: "
            (bookmark-all-names)
            :history 'bookmark-history
            :action (lambda (x)
                      (cond ((and counsel-bookmark-avoid-dired
                                  (member x (bookmark-all-names))
                                  (file-directory-p (bookmark-location x)))
                             (with-ivy-window
                               (let ((default-directory (bookmark-location x)))
                                 (counsel-find-file))))
                            ((member x (bookmark-all-names))
                             (with-ivy-window
                               (bookmark-jump-other-window x)))
                            (t
                             (bookmark-set x))))
            :caller 'counsel-bookmark))
(global-set-key (kbd "C-x r B") 'counsel-bookmark-other-window)

;; More colors in dired.
(straight-use-package 'diredfl)
(diredfl-global-mode +1)
(setq diredfl-ignore-compressed-flag nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diredfl-autofile-name ((t (:background "dark" :foreground "#ff0000"))))
 '(diredfl-compressed-file-name ((t (:background "dark" :foreground "#d79921"))))
 '(diredfl-compressed-file-suffix ((t (:background "dark" :foreground "#d79921"))))
 '(diredfl-date-time ((t (:background "dark" :foreground "#b8bb26"))))
 '(diredfl-deletion ((t (:background "dark" :foreground "#fb4934"))))
 '(diredfl-deletion-file-name ((t (:background "dark" :foreground "#cc241d"))))
 '(diredfl-dir-heading ((t (:background "dark" :foreground "#a89984"))))
 '(diredfl-dir-name ((t (:background "dark" :foreground "#83a598"))))
 '(diredfl-dir-priv ((t (:background "dark" :foreground "#83a598"))))
 '(diredfl-exec-priv ((t (:background "dark" :foreground "#689d6a"))))
 '(diredfl-executable-tag ((t (:background "dark" :foreground "#689d6a"))))
 '(diredfl-file-name ((t (:background "dark" :foreground "#ebdbb2"))))
 '(diredfl-file-suffix ((t (:background "dark" :foreground "#ebdbb2"))))
 '(diredfl-flag-mark ((t (:background "dark" :foreground "#689d6a"))))
 '(diredfl-flag-mark-line ((t (:background "#504945" :foreground "#8ec07c"))))
 '(diredfl-ignored-file-name ((t (:background "dark" :foreground "#928374"))))
 '(diredfl-link-priv ((t (:background "dark" :foreground "#d79921"))))
 '(diredfl-no-priv ((t (:background "dark" :foreground "#928374"))))
 '(diredfl-number ((t (:background "dark" :foreground "#fe8019"))))
 '(diredfl-other-priv ((t (:background "dark" :foreground "#fabd2f"))))
 '(diredfl-rare-priv ((t (:background "dark" :foreground "#fb4934"))))
 '(diredfl-read-priv ((t (:background "dark" :foreground "#98971a"))))
 '(diredfl-symlink ((t (:background "dark" :foreground "#b8bb26"))))
 '(diredfl-tagged-autofile-name ((t (:background "dark" :foreground "#ebdbb2"))))
 '(diredfl-write-priv ((t (:background "dark" :foreground "#cc241d")))))
