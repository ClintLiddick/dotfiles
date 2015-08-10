;; QuickLisp
(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")


;; Packages
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))


;; Vim
(require 'evil)
(evil-mode 1)
(evilnc-default-hotkeys)
(setq viper-mode t)
;;(require 'viper)
;;(setq viper-expert-level '5)


;; Misc
(setq diff-switches "-u") ; unified diffs
(global-linum-mode t)
(setq linum-format "%d ")
(setq browse-url-generic-program "google-chrome")
(setq make-backup-files nil)


;; company-mode autocompletion
(add-hook 'after-init-hook 'global-company-mode)
(slime-setup '(slime-company))
(add-hook 'python-mode-hook (lambda () (add-to-list 'company-backends 'company-jedi)))


;; ROS
(add-to-list 'load-path "/opt/ros/indigo/share/emacs/site-lisp")
(require 'rosemacs-config)
(require 'slime-config "/opt/ros/indigo/share/slime_ros/slime-config.el")


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
