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

;; Colors
(straight-use-package 'gruvbox-theme)
(load-theme 'gruvbox-dark-hard t)

;; Magit and vc configuration
(straight-use-package 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(setq vc-follow-symlinks t)

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
(projectile-global-mode)
(setq projectile-completion-system 'ido)
(global-set-key "\C-xf" 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

; Ivy/Counsel/Swiper
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

;; Remove?
(straight-use-package 'amx)

; Deadgrep
(straight-use-package 'deadgrep)

;; Web stuff
(straight-use-package 'web-mode)

;; ido configuration
;;(ido-mode 1)
;;(ido-everywhere 1)
;;(ido-ubiquitous-mode 1)
;;(setq ido-use-faces t)
;; 
;;;; ido-vertical configuration
;;(ido-vertical-mode 1)
;;(setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
;;(setq ido-vertical-show-count t)
;;(set-face-attribute 'ido-vertical-first-match-face nil
;;                    :background nil
;;                    :foreground "orange")
;;(set-face-attribute 'ido-vertical-only-match-face nil
;;                    :background nil
;;                    :foreground nil)
;;(set-face-attribute 'ido-vertical-match-face nil
;;                    :foreground nil)
;;

;; Projectile configuration.

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

;; Don't show the startup screen and show only minimal text in the scratch buffer.
(setq inhibit-startup-screen t
      initial-scratch-message ";; ready\n\n")

;;(require 'doom-modeline)
;;(doom-modeline-mode 1)
;;(add-hook 'after-init-hook #'doom-modeline-mode)
;;(setq doom-modeline-project-detection 'project)

;;(use-package helm :config (require 'helm-config))
;;(require 'helm)
;;(helm-mode 1)
