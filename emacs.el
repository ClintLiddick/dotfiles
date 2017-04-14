;;; emacs-config --- my personal .emacs.el
;;; Commentary:

;;; Code:

;; don't put custom-set-variables in emacs.el
(setq custom-file (make-temp-file "emacs-custom"))
;; setup package archives
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; manually install use-package package manager
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; configure use-package
(setq use-package-always-ensure t)  ;; always download and install packages
(setq use-package-always-pin "melpa-stable")  ;; prefer stable
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(require 'diminish)
(use-package cl)


;; automatically update packages daily
(use-package spu
  :pin melpa
  :defer
  :config (spu-package-upgrade-daily))

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
(use-package flycheck
  :config
  (global-flycheck-mode)
  (use-package flycheck-irony)
  (add-hook 'flycheck-mode-hooqk 'flycheck-irony-setup)
  (add-hook 'c++-mode-hook
            (lambda()
              (setq flycheck-gcc-language-standard "c++11")
              (setq flycheck-clang-language-standard "c++11")))
  (add-hook 'c-mode-hook
            (lambda()
              (setq flycheck-gcc-language-standard "c11")
              (setq flycheck-clang-language-standard "c11")))
  (use-package flycheck-rust
    :pin melpa))


;; C++
;; auto-formatting
(use-package clang-format
  :pin melpa
  :config
  (evil-leader/set-key-for-mode 'c++-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'c++-mode "F" 'clang-format-region)
  (evil-leader/set-key-for-mode 'c-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'c-mode "F" 'clang-format-region))

;; completion and search server
(use-package irony
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook
            (lambda ()
              (define-key irony-mode-map [remap completion-at-point]
                'irony-completion-at-point-async)
              (define-key irony-mode-map [remap complete-symbol]
                'irony-completion-at-point-async)))
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))


;; ivy general completion
(use-package ivy
  :diminish (ivy-mode . "")
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode 1))
(use-package swiper)
(use-package ivy-hydra)
(use-package counsel
  :init
  (setq counsel-ag-base-command "rg --color=never --no-heading -H -e %s")
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c /" . counsel-ag)
         ("C-c l" . counsel-locate)))


;; projectile project interaction
(use-package projectile
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-global-mode))


;; company code autocomplete
(use-package company
  :defer
  :init (global-company-mode)
  :bind ("TAB" . company-indent-or-complete-common)
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)

  ;; the company-clang and company-c-headers can usually be replaced by
  ;; more powerful company-irony versions, but those require the
  ;; cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON flag in order to work
  ;; so we'll leave the original versions as fallback

  ;; remove semantic so company-clang will actually be used
  (setq company-backends (delete 'company-semantic company-backends))
  ;; (use-package company-flx)
  (use-package company-c-headers
    :pin melpa
    :config
    (add-to-list 'company-c-headers-path-system "/usr/include/c++/5")
    (add-to-list 'company-backends 'company-c-headers))

  (use-package company-irony
    :config
    (use-package company-irony-c-headers)
    (add-to-list 'company-backends '(company-irony-c-headers company-irony)))

  (use-package company-jedi
    :config
    (add-to-list 'company-backends 'company-jedi))

  (use-package company-lua
    :pin melpa)
  (use-package company-racer
    :pin melpa)
  (use-package company-web)
  (use-package web-completion-data))


;; git
(use-package git-commit)
(use-package magit
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  :bind ("C-x g" . magit-status))


;; python
(use-package jedi)
(use-package jedi-core)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")


;; rust
(use-package rust-mode
  :mode "\\.rs\\'"
  :config
  (use-package racer
    :pin melpa
    :config
    (add-hook 'rust-mode-hook 'racer-mode))
  (evil-leader/set-key-for-mode 'rust-mode "f" 'rust-format-buffer))
(use-package cargo)


;; AUCTeX (LaTeX)
(use-package tex
  :ensure auctex
  :init
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq reftex-plug-into-AUCTeX t)
  (setq TeX-PDF-mode t)
  :config
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex))


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
(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'"
         "\\.cmake\\'"))
(use-package dockerfile-mode :mode "Dockerfile\\'")
(use-package lua-mode
  :mode ("\\.lua\\'"
         "\\.t\\'"))  ; terra files
(use-package markdown-mode
  :mode "\\.md\\'"
  :init (setq markdown-command "markdown2"))
(use-package matlab-mode
  :pin melpa
  :mode "\\.m\\'")
(use-package nginx-mode :mode "/.*/sites-\\(?:available\\|enabled\\)/")
(use-package yaml-mode
  :mode ("\\.yaml\\'"
         "\\.yml\\'"
         "\\.sls\\'"))  ; salt files
(add-to-list 'auto-mode-alist '("\\.launch\\'" . xml-mode))
(use-package protobuf-mode
  :mode "\\.proto\\'")


;; misc packages
(use-package hl-todo)
(use-package undo-tree
  :diminish (undo-tree-mode . ""))
(use-package with-editor)


;; misc configuration
(setq diff-switches "-u") ; unified diffs
(global-linum-mode t)
(setq linum-format "%d ")
(setq column-number-mode t)
(setq browse-url-generic-program "google-chrome")
(setq make-backup-files nil)
(setq gdb-many-windows t)


;; indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-offset tab-width)
(setq c-default-style "linux")
(setq cperl-indent-level tab-width)
(setq lua-indent-level 2)


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
(add-to-list 'default-frame-alist '(font . "DejaVuSansMono-12"))
(if (display-graphic-p)
    (set-frame-font "DejaVuSansMono-12"))
(setq color-themes '())
(use-package color-theme-solarized
  :pin melpa
  :config
  ;; (load-theme 'solarized t)
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (select-frame frame)
                  (load-theme 'solarized t)
                  (when (display-graphic-p frame)
                    (set-frame-font "DejaVuSansMono-12"))))))

;;; emacs.el ends here
