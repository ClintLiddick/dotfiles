;;; emacs-config --- my personal .emacs.el
;;; Commentary:

;;; Code:

;; don't put custom-set-variables in emacs.el
(setq custom-file (make-temp-file "emacs-custom"))
;; setup package archives
(require 'package)
;;(package-initialize)
;;(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; manually install use-package package manager
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; configure use-package
(setq use-package-always-ensure t)  ;; always download and install packages
(setq use-package-always-pin "melpa")  ;; prefer latest
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(use-package cl)
(use-package diminish)

;; evil - vi emulation
(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-key "f" 'indent-according-to-mode)
  (evil-leader/set-key "F" 'indent-region))
(use-package evil
  :config
  (evil-mode 1)
  (use-package evil-nerd-commenter
    :bind (("M-;" . evilnc-comment-or-uncomment-lines)
           :map evil-normal-state-map
           ("/" . swiper))))


;; flycheck syntax checking
;; Python - flake8
;; C++ - clang/gcc/cppcheck
;; Rust - cargo
;; Javascript - eslint
;; LaTeX - chktex
;; SQL - sqlint
;; Shell - shellcheck
(use-package flycheck
  :config
  (global-flycheck-mode)
  ;; (use-package flycheck-irony)
  ;; (add-hook 'flycheck-mode-hook 'flycheck-irony-setup)
  (setq flycheck-shellcheck-follow-sources nil)  ; Old version of shellcheck
  (add-hook 'c++-mode-hook
            (lambda()
              (setq flycheck-gcc-language-standard "c++14")
              (setq flycheck-clang-language-standard "c++14")))
  (add-hook 'c-mode-hook
            (lambda()
              (setq flycheck-gcc-language-standard "c11")
              (setq flycheck-clang-language-standard "c11")))
  (use-package flycheck-ycmd
    :config
    (flycheck-ycmd-setup))
  (use-package flycheck-rust))


;; C++
;; auto-formatting
(use-package clang-format
  :config
  (setq clang-format-executable "~/.local/bin/clang-format")
  (evil-leader/set-key-for-mode 'c++-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'c++-mode "F" 'clang-format-region)
  (evil-leader/set-key-for-mode 'c-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'c-mode "F" 'clang-format-region)
  (evil-leader/set-key-for-mode 'protobuf-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'protobuf-mode "F" 'clang-format-region)
  (evil-leader/set-key-for-mode 'glsl-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'glsl-mode "F" 'clang-format-region))


;; YouCompleteMe
(use-package ycmd
  :init
  ;; (set-variable 'ycmd-global-config "~/dotfiles/ycmd_extra_conf.py")
  (set-variable 'ycmd-extra-conf-whitelist (list (file-truename "~/av/*") (file-truename "~/av2/*")))
  (set-variable 'ycmd-server-command (list "python3" (file-truename "~/src/ycmd/ycmd")))
  :config
  (ycmd-setup)
  (add-hook 'after-init-hook #'global-ycmd-mode))


;; ivy general completion
(use-package ivy
  :diminish (ivy-mode . "")
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode 1))
;; (use-package swiper)
(use-package ivy-hydra)
(use-package counsel
  :init
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c /" . counsel-rg)
         ("C-c l" . counsel-locate)))


;; projectile project interaction
(use-package projectile
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-register-project-type
   'bazel
   '("WORKSPACE")
   :compile "bazel build "
   :test "bazel test "
   :run "bazel run "
   :test-prefix "test_"
   :test-suffix "_test"))

;; company code autocomplete
(use-package company
  :defer
  :init (global-company-mode)
  :bind ("TAB" . company-indent-or-complete-common)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2)

  (setq company-backends (delete 'company-semantic company-backends))
  (setq company-backends (delete 'company-clang company-backends)))

(use-package company-c-headers
  :config
  (add-to-list 'company-c-headers-path-system "/usr/include/c++/5"))
(add-to-list 'company-backends 'company-c-headers)

(use-package company-ycmd
  :config
  (company-ycmd-setup))

;; TODO: remove in favor of ycm jedi completion
(use-package company-jedi
  :config
  (add-to-list 'company-backends 'company-jedi))

;;(use-package company-lua)
;;(use-package company-racer)
;;(use-package company-web)
;;(use-package web-completion-data)


;; git
(use-package with-editor)
(use-package git-commit)
(use-package magit
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  :bind ("C-x g" . magit-status))


;;;; python
;;(use-package jedi)
;;(use-package jedi-core)
(use-package yapfify
  :config
  (evil-leader/set-key-for-mode 'python-mode "f" 'yapfify-buffer))
(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "--simple-prompt -i")


;; rust
;;(use-package rust-mode
;;  :mode "\\.rs\\'"
;;  :config
;;  (evil-leader/set-key-for-mode 'rust-mode "f" 'rust-format-buffer))
;;(use-package racer
;;:config
;;(add-hook 'rust-mode-hook 'racer-mode))
;;(use-package cargo)


;; haskell
;;(use-package haskell-mode
;;  :mode ("\\.hs\\'" "\\.ls\\'"))


;; AUCTeX (LaTeX)
;;(use-package tex
;;  :ensure auctex
;;  :init
;;  (setq TeX-auto-save t)
;;  (setq TeX-parse-self t)
;;  (setq-default TeX-master nil)
;;  (setq reftex-plug-into-AUCTeX t)
;;  (setq TeX-PDF-mode t)
;;  :config
;;  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
;;  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;;  (add-hook 'LaTeX-mode-hook 'turn-on-reftex))


;; neotree code directory tree viewer
(use-package neotree
  :config
  (setq neo-smart-open t)
  (evil-leader/set-key "s" 'neotree-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide))


;; mode packages
;;(use-package cmake-mode
;;  :mode ("CMakeLists\\.txt\\'"
;;         "\\.cmake\\'"))
(use-package dockerfile-mode :mode "Dockerfile\\'")
;;(use-package lua-mode
;;  :mode ("\\.lua\\'"
;;         "\\.t\\'"))  ; terra files
(use-package groovy-mode)
  ;; :mode "av-.*\\[a-z\\]\\'")
;; (add-to-list 'auto-mode-alist '("av-.*\\[a-z\\]\\'" . groovy-mode))
(use-package markdown-mode
  :mode "\\.md\\'"
  :init (setq markdown-command "markdown2"))
;;(use-package matlab-mode
;;  :mode "\\.m\\'")
(use-package nginx-mode :mode "/.*/sites-\\(?:available\\|enabled\\)/")
(use-package yaml-mode
  :mode ("\\.yaml\\'"
         "\\.yml\\'"
         "\\CROSSTOOL\\'"
         "\\.cfg\\'"
         "\\.sls\\'"))  ; salt files
;;(add-to-list 'auto-mode-alist '("\\.launch\\'" . xml-mode))
(use-package protobuf-mode
  ;; :load-path "~/dotfiles/third_party/"
  :mode "\\.proto\\'")
;; (add-to-list 'auto-mode-alist '("\\BUILD\\'" . python-mode))
;; (add-to-list 'auto-mode-alist '("\\.bzl\\'" . python-mode))
;;(use-package glsl-mode
;;  :mode "\\.glsl")


;; misc packages
;;(use-package hl-todo
;;  :config
;;  (global-hl-todo-mode 1))


;; misc configuration
(setq diff-switches "-u") ; unified diffs
(global-linum-mode t)
(setq linum-format "%d ")
(setq column-number-mode t)
(setq browse-url-generic-program "firefox")
(setq make-backup-files nil)
(setq gdb-many-windows t)
(show-paren-mode t)
(setq show-paren-delay 0)
(setq-default fill-column 100)


;; indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-offset tab-width)
(setq c-default-style "linux")
(setq cperl-indent-level tab-width)
(setq lua-indent-level 2)
(setq yaml-indent-offset 2)


;; mouse
(use-package xt-mouse
  :config (xterm-mouse-mode t))

;; enable mouse scrolling in terminal
(defvar alternating-scroll-down-next t)
(defvar alternating-scroll-up-next t)

(defun alternating-scroll-down-line ()
  (interactive "@")
  (when alternating-scroll-down-next
    (scroll-down-line))
  (setq alternating-scroll-down-next (not alternating-scroll-down-next)))

(defun alternating-scroll-up-line ()
  (interactive "@")
  (when alternating-scroll-up-next
    (scroll-up-line))
  (setq alternating-scroll-up-next (not alternating-scroll-up-next)))

(when (not (display-graphic-p))
  (global-set-key (kbd "<mouse-4>") 'alternating-scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'alternating-scroll-up-line))


;; theme and font
(defvar clint-font (if (equal (system-name) "marvin")
                       "SourceCodePro-10"
                       "SourceCodePro-12"))
(if (display-graphic-p)
    (set-frame-font clint-font))
(defvar color-themes '())
(use-package zenburn-theme
  :config
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (select-frame frame)
                  (load-theme 'zenburn t)
                  (when (display-graphic-p frame)
                    (set-frame-font clint-font))))))


(global-prettify-symbols-mode t)

;;; emacs.el ends here
