;; Packages
(require 'cl-lib nil t)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(defvar clint-packages
  '(async                ;; Asynchronous processing in Emacs
    auctex               ;; TeX/LaTeX editing package
    clang-format         ;; Format code using clang-format
    cmake-font-lock      ;; Advanced, type aware, highlight support for CMake
    cmake-mode           ;; No description available.
    color-theme-solarized;; Solarized themees for Emacs
    company              ;; Modular text completion framework
    company-flx          ;; flx based fuzzy matching for company
    company-jedi         ;; company-mode completion back-end for Python JEDI
    company-racer        ;; company-mode completion back-end for rust racer
    company-web          ;; Company version of ac-html, complete for web,html,emmet,jade,slim modes
    concurrent           ;; Concurrent utility functions for emacs lisp
    ctable               ;; Table component for Emacs Lisp
    dash                 ;; A modern list library for Emacs
    deferred             ;; Simple asynchronous functions for emacs lisp
    dockerfile-mode      ;; Major mode for editing Docker's Dockerfiles
    epc                  ;; A RPC stack for the Emacs Lisp
    epl                  ;; Emacs Package Library
    evil                 ;; Extensible Vi layer for Emacs.
    evil-leader          ;; let there be <leader>
    evil-nerd-commenter  ;; Comment/uncomment lines efficiently. Like Nerd Commenter in Vim
    evil-numbers         ;; increment / decrement binary, octal, decimal and hex literals
    flx                  ;; fuzzy matching with good sorting
    flx-ido              ;; flx integration for ido
    flycheck             ;; on-the-fly syntax checking
    flycheck-rust        ;; flycheck backend for rust
    git-commit           ;; Edit Git commit messages
    goto-chg             ;; goto last change
    hl-todo              ;; highlight TODO keywords
    jedi                 ;; a Python auto-completion for Emacs
    jedi-core            ;; Common code of jedi.el and company-jedi.el
    lua-mode             ;; a major-mode for editing Lua scripts
    magit                ;; A Git porcelain inside Emacs
    magit-popup          ;; Define prefix-infix-suffix command combos
    markdown-mode        ;; Emacs Major mode for Markdown-formatted text files
    matlab-mode          ;; major mode for editing MATLAB files
    nginx-mode           ;; major mode for editing nginx config files
    pkg-info             ;; Information about packages
    popup                ;; Visual Popup User Interface
    projectile           ;; Manage and navigate projects in Emacs easily
    python-environment   ;; virtualenv API for Emacs Lisp
    racer                ;; Autocompletion with racer for rust
    rust-mode            ;; Major mode for editing rust files
    sr-speedbar          ;; Same frame speedbar
    todotxt-mode         ;; Major mode for editing todo.txt files
    undo-tree            ;; Treat undo history as a tree
    web-completion-data  ;; Shared completion data for ac-html and company-web
    with-editor          ;; Use the Emacsclient as $EDITOR
    yaml-mode            ;; Major mode for editing YAML file
    )
  "A list of packages to ensure are installed at launch.")

;; activate all packages (in particular autoloads)
(package-initialize)

;;
;; custom package installation, adapted from https://github.com/bbatsov/prelude
;;
(defun clint-packages-installed-p ()
  "Check if all packages in `clint-packages' are installed."
  (cl-every #'package-installed-p clint-packages))

(defun clint-require-package (package)
  "Install PACKAGE unless already installed."
  (unless (memq package clint-packages)
    (add-to-list 'clint-packages package))
  (unless (package-installed-p package)
    (package-install package)))

(defun clint-require-packages (packages)
  "Ensure PACKAGES are installed.
Missing packages are installed automatically."
  (mapc #'clint-require-package packages))

(defun clint-install-packages ()
  "Install all packages listed in `clint-packages'."
  (unless (clint-packages-installed-p)
    ;; check for new packages (package versions)
    (message "%s" "Emacs is now refreshing its package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    ;; install the missing packages
    (clint-require-packages clint-packages)))

;; run package installation
(clint-install-packages)


;; Vim
(require 'evil-leader)
(global-evil-leader-mode) ; default leader is \
(require 'evil-numbers)
(evil-leader/set-key "+" 'evil-numbers/inc-at-pt)
(evil-leader/set-key "0" 'evil-numbers/dec-at-pt)
(require 'evil)
(evil-mode 1)
(evil-leader/set-key "q" 'evil-quit)
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)


;; Misc
(setq diff-switches "-u") ; unified diffs
(global-linum-mode t)
(setq column-number-mode t)
(setq linum-format "%d ")
(setq browse-url-generic-program "google-chrome")
(setq make-backup-files nil)
(setq python-shell-interpreter "ipython")
(setq compilation-scroll-output 'first-error)


;; Indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq c-basic-offset tab-width)
(setq c-default-style "linux")
(setq cperl-indent-level tab-width)


;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'c++-mode-hook (lambda()
                           (setq flycheck-gcc-language-standard "c++11")
                           (setq flycheck-clang-language-standard "c++11")))

;; checkers:
;; Python - flake8
;; C++ - clang/gcc/cppcheck
;; Rust - cargo
;; Javascript - eslint
;; LaTeX - chktex
;; SQL - sqlint


;; clang-format
(require 'clang-format)
(evil-leader/set-key-for-mode 'c++-mode "f" 'clang-format-buffer)
(evil-leader/set-key-for-mode 'c-mode "f" 'clang-format-buffer)


;; company-mode autocompletion
(require 'company)
(require 'company-web-html)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
(add-hook 'python-mode-hook (lambda () (add-to-list 'company-backends 'company-jedi)))


;; speedbar
(require 'sr-speedbar) ;; for use in terminals
(if (display-graphic-p)
  (evil-leader/set-key "s" 'speedbar)
  (evil-leader/set-key "s" 'sr-speedbar-toggle))


;; Todo.txt
(setq todotxt-default-file (expand-file-name "~/Dropbox/todo.txt"))
(setq todotxt-default-archive-file (expand-file-name "~/Dropbox/done.txt"))
(require 'todotxt-mode)


;; Projectile
(projectile-global-mode)
(setq projectile-switch-project-action 'projectile-dired)


;; Magit
(global-set-key (kbd "C-x g") 'magit-status)


;; rust/racer
(require 'rust-mode)
(setq racer-cmd "/usr/local/bin/racer")
(setq racer-rust-src-path "/usr/local/src/rust/src")
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(evil-leader/set-key-for-mode 'rust-mode "f" 'rustfmt-format-buffer)


;; AUCTeX (LaTeX)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)


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

(when (not (display-graphic-p))
  (global-set-key (kbd "<mouse-4>") 'alternating-scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'alternating-scroll-up-line))


;; Custom Filetypes
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.urdf\\'" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.srdf\\'" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.xacro\\'" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.launch\\'" . xml-mode))

;; Look
;; (load-theme 'adwaita)
;; GUI
(when (display-graphic-p)
  (set-frame-font "DejaVuSansMono-10")
  (load-theme 'solarized t))
(add-to-list 'default-frame-alist '(font . "DejaVuSansMono-10"))


;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-generic))
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(projectile-project-root-files
   (quote
    ("rebar.config" "project.clj" "SConstruct" "pom.xml" "build.sbt" "build.gradle" "Gemfile" "requirements.txt" "setup.py" "tox.ini" "package.json" "gulpfile.js" "Gruntfile.js" "bower.json" "composer.json" "Cargo.toml" "mix.exs" "stack.yaml" "package.xml")))
 '(speedbar-show-unknown-files t)
 '(sr-speedbar-right-side nil))
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
