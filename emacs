(require 'slime-config "/opt/ros/indigo/share/slime_ros/slime-config.el") ; slime_ros provides slime
; QuickLisp
(setq inferior-lisp-program "sbcl")
(add-to-list 'slime-contribs 'slime-fancy)


;; Packages
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))


;; Vim
(setq evil-toggle-key "") ; remove default C-z toggle
(require 'evil)
(evil-mode 1)
(evilnc-default-hotkeys)


;; Misc
(setq diff-switches "-u") ; unified diffs
(global-linum-mode t)
(setq linum-format "%d ")
(setq browse-url-generic-program "google-chrome")
(setq make-backup-files nil)
(setq-default indent-tabs-mode nil)
(setq tab-width 4)


;; company-mode autocompletion
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'python-mode-hook (lambda () (add-to-list 'company-backends 'company-jedi)))


;; Mouse
(require 'xt-mouse)
(xterm-mouse-mode)
(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))
(setq mouse-wheel-follow-mouse 't)

;; enable mouse scrolling in terminal
(defvar alternating-scroll-down-next t)
(defvar alternating-scroll-up-next t)

(defun alternating-scroll-down-line ()
  (interactive "@")
  (when alternating-scroll-down-next
					;      (run-hook-with-args 'window-scroll-functions )
    (scroll-down-line))
  (setq alternating-scroll-down-next (not alternating-scroll-down-next)))

(defun alternating-scroll-up-line ()
  (interactive "@")
  (when alternating-scroll-up-next
					;      (run-hook-with-args 'window-scroll-functions)
    (scroll-up-line))
  (setq alternating-scroll-up-next (not alternating-scroll-up-next)))

(global-set-key (kbd "<mouse-4>") 'alternating-scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'alternating-scroll-up-line)


;; Filetypes
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))

;; Look
;; (load-theme 'adwaita)


;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-generic))
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(font-lock-function-name-face ((t (:foreground "brightblue")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-function-name-face ((t (:foreground "brightblue")))))
