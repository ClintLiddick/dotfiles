;;; emacs-config --- my personal .emacs.el
;;; Commentary:

;;; Code:

;; Set Python3 as default
(setq py-python-command "/usr/bin/python3")

;; determine whether or not on work computer
(defconst clint/mac (eq system-type 'darwin))
(defconst clint/work-computer (equal (system-name) "clint-vdesk"))
(defconst clint/clang-version (if clint/work-computer "15" "13"))

(defconst clint/extra-include-base
  (if (not clint/work-computer)
    "/home/clint/personal_projects"))

;; setup package archives
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; manually install use-package package manager
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; configure use-package

;; per magit recommendation, override default and allow upgrade of built-in packages
(setq package-install-upgrade-built-in t)
;; always download and install use-package packages
(setq use-package-always-ensure t)
;; prefer latest, not stable
(setq use-package-always-pin "melpa")
(eval-when-compile
  (require 'use-package))

;; core packages
(require 'bind-key)
;; allow minor modes to be hidden on mode bar
(use-package diminish)
(use-package persistent-soft)

;; automatically update packages weekly
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  ;; update unprompted but not at startup to prevent login hangs from daemon
  ;; startup blocking on networked updates
  (auto-package-update-at-time "12:30"))

;; Set Emacs PATH from shell PATH because OSX makes it almost impossible to configure
;; system-wide PATH.
(if clint/mac
    (use-package exec-path-from-shell
      :config (if (display-graphic-p)
                  (exec-path-from-shell-initialize))))

;; evil-leader: fast \-prefixed shortcuts
;; must come before (use-package evil)
(use-package evil-leader
  :init
  (setq evil-want-integration t) ;; default
  (setq evil-want-keybinding nil)
  :config
  (global-evil-leader-mode)
  (evil-leader/set-key "f" 'indent-according-to-mode)
  (evil-leader/set-key "F" 'indent-region))

;; evil: vi emulation. I'm that kind of heathen.
(use-package evil
  :init
  (setq evil-want-integration t) ;; default
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; evilnc: fast code comment/uncomment
  (use-package evil-nerd-commenter
    :config
    :bind (("M-;" . evilnc-comment-or-uncomment-lines)
           :map evil-normal-state-map
           ("/" . swiper))))

(evil-leader/set-key
  "\\" 'evilnc-comment-or-uncomment-lines  ;; single \
  "ci" 'evilnc-comment-or-uncomment-lines
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region)

;; git helper packages

;; invoke emacs from command line with temp files
(use-package with-editor)
;; required to manually "install" built-in "transient" package for magit
(use-package transient)
;; superpowered git interface
(use-package magit
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  (if clint/work-computer
    (setq display-buffer-alist
            '(("\\magit: .*"
            (display-buffer-reuse-window display-buffer-in-side-window)
            (side . right)
            (window-width . 0.5)))))

  :bind ("C-x g" . magit-status))
(evil-leader/set-key "g" 'magit-status)

(with-eval-after-load 'magit
  ;; This disables slow parts of the status page, set "magit-refresh-verbose" to "t"
  ;; to see how long the update takes and the breakdown of timing per hook in
  ;; newer versions.
  ;; Reference: https://jakemccrary.com/blog/2020/11/14/speeding-up-magit/
  (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent))


;; ivy minibuffer completion
(use-package ivy
  :diminish (ivy-mode . "")
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode 1))
;; swiper: ivy package for in-file text/regex searching
(use-package swiper)
;; counsel: ivy package for file searching
(use-package counsel
  :init
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c /" . counsel-rg)
         ("C-c l" . counsel-locate)))


;; projectile: project interaction
;;(use-package projectile
;;  :init (setq projectile-completion-system 'ivy)
;;  :config
;;  (projectile-mode +1)
;;  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))
;;  ;; Add "bazel" project type
;;  (projectile-register-project-type
;;   'bazel
;;   '("WORKSPACE")  ;; identifier file for a bazel project type
;;   :compile "bazel build "
;;   :test "bazel test "
;;   :run "bazel run -- "
;;   :test-prefix "test_"
;;   :test-suffix "_test"))

;; flycheck syntax checking
;; Python - flake8
;; C++ - clang/gcc/cppcheck
;; Rust - cargo
;; Javascript - eslint
;; LaTeX - chktex
;; SQL - sqlint
;; Shell - shellcheck
;; Protobuf - protoc
(use-package flycheck
  :config
  (global-flycheck-mode)
  (setq flycheck-protoc-import-path '(clint/extra-include-base))
  (add-hook 'c++-mode-hook
            (lambda()
              (setq flycheck-gcc-language-standard "c++14")
              (setq flycheck-clang-language-standard "c++14")))
  (add-hook 'c-mode-hook
            (lambda()
              (setq flycheck-gcc-language-standard "c11")
              (setq flycheck-clang-language-standard "c11"))))

(use-package flycheck-rust)

;; C/C++ formatting
(use-package clang-format+
  :config
  (setq clang-format+-context 'buffer)
  (add-hook 'c-mode-common-hook #'clang-format+-mode)
  (add-hook 'protobuf-mode-hook #'clang-format+-mode)
  (add-hook 'glsl-mode-hook #'clang-format+-mode)
  (evil-leader/set-key-for-mode 'c++-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'c++-mode "F" 'clang-format-region)
  (evil-leader/set-key-for-mode 'c-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'c-mode "F" 'clang-format-region)
  (evil-leader/set-key-for-mode 'protobuf-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'protobuf-mode "F" 'clang-format-region)
  (evil-leader/set-key-for-mode 'glsl-mode "f" 'clang-format-buffer)
  (evil-leader/set-key-for-mode 'glsl-mode "F" 'clang-format-region))

;; black: python formatting
(use-package python-black
  :after python
  :config
  (evil-leader/set-key-for-mode 'python-mode "f" 'python-black-buffer))


;; company: code autocomplete
(use-package company
  :defer
  :init (global-company-mode)
  :bind ("TAB" . company-indent-or-complete-common)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2))
  ;; (setq company-clang-executable (concat "clang-" clint/clang-version))
  ;; (setq company-clang-arguments
  ;;       (list
  ;;        (concat "-I" clint/extra-include-base)
  ;;        (concat "-I" (expand-file-name "bazel-bin" clint/extra-include-base)))))

(use-package company-box
  :config
  (if (display-graphic-p)
      (add-hook 'company-mode-hook 'company-box-mode)))

;; (use-package company-c-headers
;;   :config
;;   (let ((default-directory "/usr/include/c++")
;;         (gcc-versions '("5" "6" "7" "8" "9" "10" "11")))
;;     (dolist (cpp-ver gcc-versions)
;;       (add-to-list 'company-c-headers-path-system (expand-file-name cpp-ver))))
;;   (add-to-list 'company-c-headers-path-user clint/extra-include-base))

(require 'eglot)  ;; built-in
(add-to-list 'eglot-server-programs
             `(,'(c++-mode c-mode)
               ,(concat "clangd-" clint/clang-version) "--background-index=false"))
(add-hook 'c-mode-common-hook 'eglot-ensure)
(add-to-list 'eglot-server-programs
             '(python-mode . ("pylsp")))
(add-hook 'python-mode-hook 'eglot-ensure)
(add-to-list 'eglot-server-programs
             '(shell-script-mode . ("bash-language-server")))  ;; installed with npm i -g
(add-hook 'shell-script-mode-hook 'eglot-ensure)


(use-package company-jedi)  ;; Python
;; (use-package company-lua)
;; (use-package company-racer)  ;; Rust
;; (use-package company-web)
;; (use-package web-completion-data)

;; GitHub Copilot integration
(use-package dash)
(use-package f)
(use-package s)
(use-package editorconfig)
(use-package copilot
  :load-path "/home/clint/dotfiles/third_party/copilot/"
  :config
  (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion))


;; Only a single backend or backend "group" is active at a time, so backends must be
;; "set" per mode rather than "appended" in general
(defun clint/company-cish-modes-hook ()
  (setq company-backends '((
                            company-c-headers
                            company-capf
                            company-clang
                            company-keywords
                            company-dabbrev-code))))

(defun clint/company-text-modes-hook ()
  (setq company-backends '((
                            company-ispell
                            company-dabbrev
                            ))))

(add-hook 'c-mode-hook 'clint/company-cish-modes-hook)
(add-hook 'c++-mode-hook 'clint/company-cish-modes-hook)

(add-hook 'fundamental-mode-hook 'clint/company-text-modes-hook)
(add-hook 'markdown-mode-hook 'clint/company-text-modes-hook)

(add-hook 'python-mode-hook
          (lambda ()
            (setq company-backends '((
                                      company-jedi
                                      company-capf
                                      company-files
                                      company-keywords
                                      company-dabbrev-code
                                      )))))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq company-backends '((
                                      company-capf
                                      company-files
                                      company-keywords
                                      company-dabbrev-code
                                      )))))

(use-package go-mode
  :config
  (evil-leader/set-key-for-mode 'go-mode "f" 'gofmt)
  (evil-leader/set-key-for-mode 'go-mode "F" 'gofmt))

(use-package lua-mode)

;; ;; rust
;; (use-package rust-mode
;;   :mode "\\.rs\\'"
;;   :config
;;   (evil-leader/set-key-for-mode 'rust-mode "f" 'rust-format-buffer))
;; (use-package racer
;;   :config
;;   (add-hook 'rust-mode-hook 'racer-mode))
;; (use-package cargo)


;; ;; haskell
;; (use-package haskell-mode
;;   :mode ("\\.hs\\'" "\\.ls\\'"))


;; ;; AUCTeX (LaTeX)
;; (use-package tex
;;   :init
;;   (setq TeX-auto-save t)
;;   (setq TeX-parse-self t)
;;   (setq-default TeX-master nil)
;;   (setq reftex-plug-into-AUCTeX t)
;;   (setq TeX-PDF-mode t)
;;   :config
;;   (add-hook 'LaTeX-mode-hook 'visual-line-mode)
;;   (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;   (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;;   (add-hook 'LaTeX-mode-hook 'turn-on-reftex))


;; neotree code directory tree viewer
(use-package neotree
  :config
  (setq neo-smart-open t)
  (evil-leader/set-key "s" 'neotree-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide))


;; file mode packages

(use-package dockerfile-mode :mode "Dockerfile.*\\'")

;; (use-package groovy-mode)

(use-package markdown-mode
  :mode "\\.md\\'"
  :init
  (setq markdown-command "markdown2")  ;; python3-markdown2
  (add-hook 'markdown-mode-hook (lambda () (set-fill-column 88)))
  :config
  (evil-leader/set-key-for-mode 'markdown-mode "f" 'fill-paragraph)
  (evil-leader/set-key-for-mode 'markdown-mode "F" 'fill-region))

(use-package nginx-mode
  :mode "/.*/sites-\\(?:available\\|enabled\\)/")

(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'" "\\.stack\\'" "\\.platform\\'" "
\\.cfg\\'" "\\.hil\\'" "\\.pb\\.txt\\'" "\\.hwversion\\'"))

(use-package protobuf-mode
  ;; use my own latest version of protobuf-mode.el from the Protobuf sources.
  :load-path "../dotfiles/third_party/"
  :mode "\\.proto\\'")

(use-package bazel
  :config
  (evil-leader/set-key-for-mode 'bazel-build-mode "f" 'bazel-buildifier)
  (evil-leader/set-key-for-mode 'bazel-workspace-mode "f" 'bazel-buildifier)
  (evil-leader/set-key-for-mode 'bazel-starlark-mode "f" 'bazel-buildifier))

(use-package terraform-mode)

(use-package dbc-mode
  :load-path "../dotfiles/third_party/")

;; (use-package cmake-mode
;;   :mode ("CMakeLists\\.txt\\'"
;;          "\\.cmake\\'"))
;; (use-package glsl-mode
;;   :mode "\\.glsl")


;; misc configuration

(setq initial-scratch-message nil)
(setq initial-major-mode 'markdown-mode)
(setq diff-switches "-u")  ;; unified diffs
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(setq linum-format "%d ")
(setq column-number-mode t)
(setq browse-url-generic-program "firefox")
(setq make-backup-files nil)
(setq gdb-many-windows t)
(show-paren-mode t)  ;; highlight matching braces
(setq show-paren-delay 0)
(setq-default fill-column 88)  ;; set line length to match black python formatting
;; don't pollute emacs.el with custom-set-variables
(setq custom-file (make-temp-file "emacs-custom"))
;; set default python interpreter
(setq python-shell-interpreter "python3")
(setq dired-listing-switches "-alh")


;; indentation

(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-offset tab-width)
(setq c-default-style "linux")
(setq cperl-indent-level tab-width)
(setq lua-indent-level 2)
(setq yaml-indent-offset 2)


;; enable mouse in terminals
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
(use-package unicode-fonts   ;; allow fallback fonts
  :config (unicode-fonts-setup))
(prefer-coding-system 'utf-8)

(when (and clint/mac (display-graphic-p))
  (set-frame-font "Source Code Pro-14" nil t))

(defvar color-themes '())
(use-package zenburn-theme
  :config
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (select-frame frame)
                  (load-theme 'zenburn t)))
    (load-theme 'zenburn t)))

(global-prettify-symbols-mode t)

;;; emacs.el ends here
