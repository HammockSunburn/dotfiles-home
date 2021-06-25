;; to consider: all-the-icons.el

;; Allow lots of garbage during startup, then go back to normal afterwards.
(setq gc-cons-threshold 64000000)
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))

;; Setup straight.el
(load-file "~/dotfiles-home/emacs/bootstrap-straight.el")

;; Simpler key bindings.
(straight-use-package 'bind-key)

;; Colors and fonts
(straight-use-package 'gruvbox-theme)
(load-theme 'gruvbox-dark-hard t)

;; Choose a font size based on screen geometry. Unfortunately, some hardware
;; (like my Lenovo laptop) reports bogus values here. So, we have pixel sizes
;; here for different reported display physical sizes and geometries, with a
;; default if we don't find a match.
(setq hs:monitors
      '(
        ;; ((mm_x mm_y geom_x geom_y) px)
        ((880 370 3840 1600) 12)   ; Dell 3818DW
        ((677 348 2560 1317) 18)   ; Lenovo Carbon X1 (VMware Workstation, non-full screen)
        ((677 348 2560 1440) 18))) ; Lenovo Carbon X1 (VMware Workstation, full-screen)

(defun hs:font-size ()
  (let* ((monitor-attr (frame-monitor-attributes (selected-frame)))
         (mm-size (cdr (assoc 'mm-size monitor-attr)))
         (geom (nthcdr 3 (assoc 'geometry monitor-attr)))
         (value (assoc (append mm-size geom) hs:monitors)))
    (if value
        (car (cdr value))
      12))) ; default

(defun hs:get-font ()
  (format "CaskaydiaCove Nerd Font Mono-%d" (hs:font-size)))

(add-to-list 'default-frame-alist (cons 'font (hs:get-font)))

;; Magit and vc configuration
(straight-use-package 'magit)
(bind-key "C-x g" #'magit-status)
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
  (set-face-background face "unspecified"))

(bind-keys
 ("C-x P"   . git-gutter:previous-hunk)
 ("C-x N"   . git-gutter:next-hunk)
 ("C-x v s" . git-gutter:stage-hunk)
 ("C-x v r" . git-gutter:revert-hunk))

;; Spaceline
(straight-use-package 'spaceline)
(spaceline-spacemacs-theme)

;; Projectile
(straight-use-package 'projectile)
(projectile-mode +1)
(bind-key "C-x f" #'projectile-find-file)
(bind-key "C-c p" #'projectile-command-map projectile-mode-map)
(setq projectile-enable-caching t)

;; Projectile can't switch to _inline.h from .h, unfortunately.
(defvar my-cpp-other-file-alist
  '(("\\.cpp\\'" (".h"))
    ("_inline\\.h\\'" (".cpp"))
    ("\\.h\\'" ("_inline.h"))))

(setq-default ff-other-file-alist 'my-cpp-other-file-alist)
(bind-key "C-c C-f" #'ff-find-other-file)

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

;; Selectrum/Prescient
(straight-use-package 'prescient)
(straight-use-package 'selectrum)
(selectrum-mode +1)
(straight-use-package 'selectrum-prescient)
(selectrum-prescient-mode +1)

;; Consult
(straight-use-package 'consult)
(setq consult-project-root-function #'projectile-project-root)

(defun my-fdfind (&optional dir)
  (interactive "P")
  (let ((consult-find-command '("fd" "--color=never" "--full-path")))
    (consult-find dir)))

(fset 'multi-occur #'consult-multi-occur)
(setq consult-narrow-key (kbd "C-+"))

(bind-keys
 ("C-x r b" . consult-bookmark)
 ("C-x b"   . consult-buffer)
 ("C-x 4 b" . consult-buffer-other-window)
 ("C-x 5 b" . consult-buffer-other-frame)
 ("C-c C-k" . consult-focus-lines)
 ("M-g k"   . consult-global-mark)
 ("M-g M-g" . consult-goto-line)
 ("M-g l"   . consult-line)
 ("M-g m"   . consult-mark)
 ("M-s m"   . consult-multi-occur)
 ("M-g o"   . consult-outline)
 ("C-c r"   . consult-register)
 ("M-g r"   . consult-ripgrep)
 ("M-y"     . consult-yank-pop))

;; Embark (debating usefulness of this)
(straight-use-package 'embark)
(straight-use-package 'embark-consult)
(add-hook 'embark-collect-mode #'embark-consult-preview-minor-mode)
(bind-key "C-S-a" #'embark-act)

;; Marginalia
(straight-use-package 'marginalia)
(bind-key "C-M-a" #'marginalia-cycle minibuffer-local-map)
(marginalia-mode +1)

(advice-add #'marginalia-cycle :after
            (lambda () (when (bound-and-true-p selectrum-mode) (selectrum-exhibit))))

(setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))

;; Disable useless things.
(menu-bar-mode -1)
(tool-bar-mode -1)
(when (display-graphic-p)
  (toggle-scroll-bar -1))

(setq scroll-preserve-screen-position 'always)

(straight-use-package 'goto-last-change)
(bind-key "C-c C-\\" #'goto-last-change)

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

;; avy
(straight-use-package 'avy)
(bind-keys
 ("C-:"   . avy-goto-char)
 ("C-'"   . avy-goto-char-timer)
 ("M-g f" . avy-goto-line)
 ("M-g w" . avy-goto-word-1)
 ("M-g e" . avy-goto-word-0))

;; Markdown
(straight-use-package 'markdown-mode)

;; YAML
(straight-use-package 'yaml-mode)

;; Ace-window
(straight-use-package 'ace-window)
(bind-key "M-o" #'ace-window)

;; Haskell
(straight-use-package 'haskell-mode)
(straight-use-package 'ghc)

;; EMMS
(straight-use-package 'emms)
(emms-all)
(emms-default-players)
(setq emms-source-file-default-directory "~/Music/")

;; MPD (Music Player Daemon)
(straight-use-package 'mpdel)
(require 'mpdel)

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
  (setq truncate-lines nil)
  (setq fill-column 120)
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; Treat .h and .ipp files as C++.
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ipp$" . c++-mode))

;; Show parentheses everywhere.
(show-paren-mode 1)
(setq show-paren-delay 0)

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
(bind-key "C-c M-r" #'revert-buffer)

;; Calc mode
;; The default key is M-tab which is already taken by Gnome.
(with-eval-after-load 'calc
  (bind-key "<backtab>" #'calc-roll-up calc-mode-map))

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

(with-eval-after-load 'dired
  (bind-keys :map dired-mode-map
             ("C-c X" . hs:rename-with-exif-date)
             ("C-c C" . hs:convert-heic)))

(setq dired-listing-switches "-alFh")

;; More colors in dired.
(straight-use-package 'diredfl)
(diredfl-global-mode +1)
(setq diredfl-ignore-compressed-flag nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-lead-face ((t (:background "#665c54" :foreground "#fabd2f"))))
 '(avy-lead-face-0 ((t (:background "#665c54" :foreground "#83a598"))))
 '(avy-lead-face-1 ((t (:background "#665c54" :foreground "#d3869b"))))
 '(avy-lead-face-2 ((t (:background "#665c54" :foreground "#83c07c"))))
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
 '(diredfl-write-priv ((t (:background "dark" :foreground "#cc241d"))))
 '(ivy-current-match ((t (:extend t :background "#458588" :foreground "#ffffc8" :underline t)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-background t)
 '(prescient-filter-method '(literal regexp initialism fuzzy)))
