(setq completion-cycle-threshold t) ;; use TAB for cycling selections
(setq enable-recursive-minibuffers t)

(setq initial-scratch-message "")

;; prefer vertical splits over horizontal
(setq split-width-threshold 0)

;;(setq-default message-log-max nil)

;; Persist history over Emacs restarts
(savehist-mode 1)

(defvar elpaca-installer-version 0.5)
  (defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
  (defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
  (defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
  (defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
				:ref nil
				:files (:defaults (:exclude "extensions"))
				:build (:not elpaca--activate-package)))
  (let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
	 (build (expand-file-name "elpaca/" elpaca-builds-directory))
	 (order (cdr elpaca-order))
	 (default-directory repo))
    (add-to-list 'load-path (if (file-exists-p build) build repo))
    (unless (file-exists-p repo)
      (make-directory repo t)
      (when (< emacs-major-version 28) (require 'subr-x))
      (condition-case-unless-debug err
	  (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
		   ((zerop (call-process "git" nil buffer t "clone"
					 (plist-get order :repo) repo)))
		   ((zerop (call-process "git" nil buffer t "checkout"
					 (or (plist-get order :ref) "--"))))
		   (emacs (concat invocation-directory invocation-name))
		   ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
					 "--eval" "(byte-recompile-directory \".\" 0 'force)")))
		   ((require 'elpaca))
		   ((elpaca-generate-autoloads "elpaca" repo)))
	      (progn (message "%s" (buffer-string)) (kill-buffer buffer))
	    (error "%s" (with-current-buffer buffer (buffer-string))))
	((error) (warn "%s" err) (delete-directory repo 'recursive))))
    (unless (require 'elpaca-autoloads nil t)
      (require 'elpaca)
      (elpaca-generate-autoloads "elpaca" repo)
      (load "./elpaca-autoloads")))
  (add-hook 'after-init-hook #'elpaca-process-queues)
  (elpaca `(,@elpaca-order))

  ;; Install use-package support
  (elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Block until current queue processed.
(elpaca-wait)

;;When installing a package which modifies a form used at the top-level
;;(e.g. a package which adds a use-package key word),
;;use `elpaca-wait' to block until that package has been installed/configured.
;;For example:
;;(use-package general :demand t)
;;(elpaca-wait)

;;Turns off elpaca-use-package-mode current declartion
;;Note this will cause the declaration to be interpreted immediately (not deferred).
;;Useful for configuring built-in emacs features.
(use-package emacs :elpaca nil :config (setq ring-bell-function #'ignore))

;; Don't install anything. Defer execution of BODY
;;(elpaca nil (message "deferred"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  ;; Disables evil in eshell. Change buffer from eshell with (C-x b)
  ;; (evil-set-initial-state 'eshell-mode 'emacs)
  (setq evil-set-undo-system 'undo-redo)
  (setq evil-inhibit-esc nil)
  :config
  (evil-set-initial-state 'minibuffer-mode 'emacs)
  (evil-mode +1))

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "RET") nil))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer magit eshell))
  (evil-collection-init))

(use-package evil-tutor)

(use-package which-key
  :init
    (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 2
        which-key-max-display-columns nil
        which-key-min-display-lines 8
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.3
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit nil
        which-key-separator " → " ))

;; (use-package counsel
;;   :after ivy
;;   :config (counsel-mode))

;; (use-package ivy
;;   :custom
;;   (setq ivy-use-virtual-buffers t)
;;   (setq ivy-count-format "(%d/%d) ")
;;   (setq ivy-wrap t)
;;   (setq ivy-action-wrap t)
;;   (setq enable-recursive-minibuffers t)
;;   ;; not working :(
;;   ;; (add-to-list 'ivy-ignore-buffers "\\*scratch\\*")
;;   ;; (add-to-list 'ivy-ignore-buffers "\\*lsp-log\\*")
;;   ;; (add-to-list 'ivy-ignore-buffers "\\*clojure-lsp\\*")
;;   ;; (add-to-list 'ivy-ignore-buffers "\\*dashboard\\*")
;;   ;; (add-to-list 'ivy-ignore-buffers "\\*Messages\\*")
;;   :config
;;   (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-next-line)
;;   (define-key ivy-minibuffer-map (kbd "J") 'ivy-next-line)
;;   (define-key ivy-minibuffer-map (kbd "K") 'ivy-previous-line)
;;   (define-key ivy-minibuffer-map (kbd "<ESC>") 'minibuffer-keyboard-quit)
;;   (define-key swiper-map (kbd "<ESC>") 'minibuffer-keyboard-quit)
;;   (ivy-mode))

;; (use-package all-the-icons-ivy-rich
;;   :ensure t
;;   :init (all-the-icons-ivy-rich-mode 1))

;; (use-package ivy-rich
;;   :after counsel
;;   :ensure t
;;   :init (setq ivy-rich-parse-remote-file-path t)
;;   :config (ivy-rich-mode 1))

;; (use-package ivy-posframe
;;   :after ivy
;;   :ensure t
;;   :custom-face
;;   (ivy-posframe-border ((t (:background "#eceff1"))))
;;   (ivy-posframe ((t (:background "#eceff1"))))
;;   :init 
;;   (setq ivy-posframe-width 100)
;;   (setq ivy-posframe-height 11)
;;   (setq ivy-posframe-border-width 32)
;;   (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
;;   (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
;;   (ivy-posframe-mode))

;; (defun ivy-with-thing-at-point (cmd)
;;   (let ((ivy-initial-inputs-alist
;;          (list
;;           (cons cmd (thing-at-point 'symbol)))))
;;     (funcall cmd)))

;; (defun counsel-ag-thing-at-point ()
;;   (interactive)
;;   (ivy-with-thing-at-point 'counsel-ag))

;; --- VERTICO ---
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  (keymap-set vertico-map "<escape>" #'abort-recursive-edit)
  (keymap-set vertico-map "?" #'minibuffer-completion-help)
  (keymap-set vertico-map "TAB" #'vertico-next)
  (keymap-set vertico-map "§" #'vertico-previous)
  (keymap-set vertico-map "M-j" #'vertico-next)
  (keymap-set vertico-map "M-k" #'vertico-previous)
  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

    ;; Option 1: Additional bindings
    ;; (keymap-set vertico-map "M-RET" #'minibuffer-force-complete-and-exit)
    ;; (keymap-set vertico-map "M-TAB" #'minibuffer-complete)

    ;; Option 2: Replace `vertico-insert' to enable TAB prefix expansion.
    ;; (keymap-set vertico-map "TAB" #'minibuffer-complete)

  (use-package vertico-posframe
     :after vertico
     :ensure t
     :custom-face
     (vertico-posframe-border ((t (:background "#eceff1"))))
     (vertico-posframe ((t (:background "#eceff1"))))
     :init
     (setq vertico-posframe-border-width 24)
     (setq vertico-posframe-width 140)
     :config 
     (evil-set-initial-state 'vertico-posframe-mode 'emacs)
     (vertico-posframe-mode 1))

  ;; --- CONSULT ---

  (use-package consult
    ;; :hook (completion-list-mode . consult-preview-at-point-mode)

    ;; The :init configuration is always executed (Not lazy)
    :init

    ;; Optionally configure the register formatting. This improves the register
    ;; preview for `consult-register', `consult-register-load',
    ;; `consult-register-store' and the Emacs built-ins.
    (setq register-preview-delay 0.5
          register-preview-function #'consult-register-format)

    ;; Optionally tweak the register preview window.
    ;; This adds thin lines, sorting and hides the mode line of the window.
    (advice-add #'register-preview :override #'consult-register-window)

    ;; Use Consult to select xref locations with preview
    (setq xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)
  )

(defun u/consult-ripgrep-symbol-at-point ()
  "Search for the symbol at point using consult-ripgrep.
   If no project is found, search in the user's home directory."
  (interactive)
  (let ((symbol (thing-at-point 'symbol))
        (search-dir (if (project-current)
                        (project-root (project-current))
                      (expand-file-name "~"))))
    (if symbol
        (consult-ripgrep search-dir symbol)
      (message "No symbol at point."))))

;; --- CORFU ---

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt)
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  ;; :bind
  ;; (:map corfu-map
  ;;   ("TAB" . corfu-next)
  ;;   ([tab] . corfu-next)
  ;;   ("S-TAB" . corfu-previous)
  ;;   ([backtab] . corfu-previous))
  :bind
  (:map corfu-map
        ("M-j" . corfu-next)
        ("TAB" . corfu-next)
        ("M-k" . corfu-previous)
        ("§" . corfu-previous))
  :config
  (corfu-popupinfo-mode)
  :init
  (global-corfu-mode))

;;(evil-make-overriding-map corfu-map)
(advice-add 'corfu--setup :after 'evil-normalize-keymaps)
(advice-add 'corfu--teardown :after 'evil-normalize-keymaps)

  ;; --- ORDERLESS ---
  (use-package orderless
    :ensure t
    :custom
    (completion-styles '(orderless basic))
    (completion-category-overrides '((file (styles basic partial-completion)))))

  ;; --- MARGINALIA ---
  (use-package marginalia
    :init
    (marginalia-mode))

(setq eshell-scroll-to-bottom-on-input 'all
      eshell-error-if-no-glob t
      eshell-hist-ignoredups t
      eshell-save-history-on-exit t
      eshell-prefer-lisp-functions nil
      eshell-destroy-buffer-when-process-dies t)

(use-package eshell-prompt-extras
    :after esh-opt
    :defines eshell-highlight-prompt
    :commands (epe-theme-lambda epe-theme-dakrone epe-theme-pipeline)
    :init (setq eshell-highlight-prompt nil
                eshell-prompt-function #'epe-theme-lambda))

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

;; (use-package projectile
;;   :config
;;   (setq projectile-indexing-method 'alien)
;;   (setq projectile-completion-system 'ivy)
;;   (setq projectile-project-search-path '(("~/dev/" . 3)))
;;   (projectile-discover-projects-in-search-path))

;;(setq async-shell-command-buffer 'display-buffer)

(setq status-ios-buffer "*Status: run-ios*")
(setq status-android-buffer "*Status: run-android*")
(setq status-clojure-buffer "*Status: shadow-cljs*")
(setq status-metro-buffer "*Status: metro*")

(add-to-list 'display-buffer-alist '(status-clojure-buffer . (display-buffer-no-window . nil)))
(add-to-list 'display-buffer-alist '(status-metro-buffer . (display-buffer-no-window . nil)))

(defun project-detached-shell-command (command &optional name)
  (interactive "MAsync shell command: \nsBuffer name (*Async Shell Command*): ")
  (let ((output-buffer (or name "*Async Shell Command*"))
        (project-root (car (last (project-current))))) ; using project.el
    (message project-root)
    (if project-root
        (let ((default-directory project-root))
          (detached-shell-command command output-buffer))
      (message "Not in a project directory."))))

(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

;; (use-package treemacs-projectile
;;   :after (treemacs projectile)
;;   :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; (use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
;;   :after (treemacs persp-mode) ;;or perspective vs. persp-mode
;;   :ensure t
;;   :config (treemacs-set-scope-type 'Perspectives))

;; (use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
;;   :after (treemacs)
;;   :ensure t
;;   :config (treemacs-set-scope-type 'Tabs))

(use-package detached
  :ensure t
  :init
  (detached-init)
  :bind (([remap async-shell-command] . detached-shell-command))
  :custom ((detached-show-output-on-attach t)
           (detached-terminal-data-command system-type)))

(use-package dashboard
  :ensure t 
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner "/Users/clungu/.config/emacs/images/emacs-dash.png")  ;; use custom image as banner
  ;;(setq dashboard-startup-banner 'default)
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-projects-backend 'project-el)
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          ;(bookmarks . 3)
                          (projects . 3)))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-mode))

;;(tab-bar-mode t)                              ;; enable tab bar
(setq tab-bar-show t)                         ;; hide bar if <= 1 tabs open
(setq tab-bar-close-button-show nil)          ;; hide tab close / X button
(setq tab-bar-new-tab-choice "*dashboard*")   ;; buffer to show in new tabs
(setq tab-bar-tab-hints t)                    ;; show tab numbers
(setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
(setq tab-bar-select-tab-modifiers '(meta))

(defun tab-bar-tab-name-format-default (tab i)
  (let ((current-p (eq (car tab) 'current-tab))
        (tab-num (if (and tab-bar-tab-hints (< i 10))
                     (format "[%d]" i) "")))
    (propertize
     (concat "  " (alist-get 'name tab) " " tab-num " ")
     'face (funcall tab-bar-tab-face-function tab))))

(setq tab-bar-tab-name-format-function #'tab-bar-tab-name-format-default)

(set-face-attribute 'tab-bar nil
                    :height 160
                    :box '(:line-width 4 :color "#FFFFFF")
                    :background "#FAFAFA"
                    :foreground "#333333")
(set-face-attribute 'tab-bar-tab nil
                    :family (face-attribute 'default :family)
                    :weight 'bold
                    :background "#81A1C1"
                    :foreground "#FAFAFA")
(set-face-attribute 'tab-bar-tab-inactive nil
                    :family (face-attribute 'default :family)
                    :slant 'italic
                    :weight 'normal
                    :background "#FFFFFF"
                    :foreground "#37474F")

(use-package burly
  :config
  (burly-tabs-mode t))

;; (use-package awesome-tab
;;   :elpaca (:host github :repo "manateelazycat/awesome-tab")
;;   :config
;;   (awesome-tab-mode t)
;;   (setq awesome-tab-cycle-scope 'tabs)
;;   (setq awesome-tab-show-tab-index t))

(use-package golden-ratio
  :config
  (golden-ratio-mode 1)
(setq golden-ratio-extra-commands
    (append golden-ratio-extra-commands
      '(evil-window-left
        evil-window-right
        evil-window-up
        evil-window-down))))

(use-package evil-mc
  :config
  (global-evil-mc-mode 1))

(use-package pandoc-mode)
(add-hook 'markdown-mode-hook 'pandoc-mode)

(use-package lsp-mode
  :init
  (setq lsp-file-watch-threshold 10000)
  (setq lsp-enable-which-key-integration t))
;; (use-package lsp-treemacs)
(use-package flycheck)
;;(use-package company)
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :init
  ;;(setq lsp-ui-sideline-show-hover 1)
  ;;(setq lsp-ui-sideline-enable nil)
  ;;(setq lsp-ui-sideline-show-symbol nil)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-doc-position 'at-point)
  ;;(setq lsp-ui-doc-use-childframe t)
  (setq lsp-ui-doc-enable 1)
  :config
  (lsp-ui-sideline-mode))

(use-package clojure-mode)
(use-package cider
  :init
  (setq cider-use-overlays t)
  (setq cider-repl-display-in-current-window t)
  (setq cider-result-overlay-position 'at-point)
  (setq clojure-toplevel-inside-comment-form t)
  (setq cider-eval-result-prefix "--> "))

;; Paredit (kinda)
(use-package evil-cleverparens)

(add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
(add-hook 'clojurescript-mode-hook #'evil-cleverparens-mode)
(add-hook 'cider-repl-mode-hook #'evil-cleverparens-mode)

(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'cider-repl-mode-hook 'lsp)

(add-hook 'clojure-mode-hook #'cider-mode)
(add-hook 'clojurescript-mode-hook #'cider-mode)
(add-hook 'cider-repl-mode-hook #'cider-mode)

(add-hook 'clojure-mode-hook 'smartparens-strict-mode)
(add-hook 'clojurescript-mode-hook 'smartparens-strict-mode)
(add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      ; company-minimum-prefix-length 1
      ; lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      )

;; Zprint

;; Doesn't work with local configs and as of yet cannot be configured
;; (use-package zprint-mode)
;; (add-hook 'clojure-mode-hook 'zprint-mode)
;; (add-hook 'clojurescript-mode-hook 'zprint-mode)
;; (add-hook 'cider-repl-mode-hook 'lsp)

;; (defun zprint-format-buffer ()
;;   "Use zprint to format the current buffer."
;;   (interactive)
;;   (let ((original-point (point)))
;;     (shell-command-on-region (point-min) (point-max) "zprint '{:search-config? true}'" (current-buffer) t)
;;     (goto-char original-point)))

;; (defun add-zprint-on-save-hook ()
;;   "Add `zprint-format-buffer` to the `before-save-hook` for Clojure files."
;;   (add-hook 'before-save-hook 'zprint-format-buffer nil t))

;; (add-hook 'clojure-mode-hook 'add-zprint-on-save-hook)
;; (add-hook 'clojurescript-mode-hook 'add-zprint-on-save-hook)

;; Rainbow delimiters
(use-package rainbow-delimiters)

(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
(add-hook 'clojurescript-mode-hook #'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)

(use-package go-mode)
(add-hook 'go-mode-hook 'lsp-deferred)

(use-package go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)

(add-hook 'go-mode-hook 'lsp)

(use-package apheleia
  :init
  (setq apheleia-log-only-errors nil)
  (setq apheleia-mode-alist
        '((clojure-mode . zprint)
          (clojurescript-mode . zprint)
          (css-mode . prettier)
          (css-ts-mode . prettier)
          (elixir-mode . mix-format)
          (go-mode . gofmt)
          (go-ts-mode . gofmt)
          (html-mode . prettier)
          (java-mode . google-java-format)
          (js-mode . prettier)
          (json-mode . prettier)
          (json-ts-mode . prettier)
          (ledger-mode . ledger)
          (nix-mode . nixfmt)
          (python-mode . black)
          (ruby-mode . prettier)
          (rust-mode . rustfmt)
          (rustic-mode . rustfmt)
          (sass-mode . prettier)
          (terraform-mode . terraform)
          (typescript-mode . prettier)
          (typescript-tsx-mode . prettier)
          (web-mode . prettier)
          (yaml-mode . prettier)))

  (setq apheleia-formatters
        `((black . ("black" "-"))
          (gofmt . ("gofmt"))
          (gofumpt . ("gofumpt"))
          (google-java-format . ("google-java-format" "-"))
          (ledger . pkg-apheleia/formatter-ledger)
          (lisp-indent . apheleia-indent-lisp-buffer)
          (mix-format . ("mix" "format" "-"))
          (nixfmt . pkg-apheleia/formatter-nixfmt)
          (ocamlformat . (ocamlformat . ("ocamlformat" "-" "--name" filepath "--enable-outside-detected-project")))
          (rustfmt . ("rustfmt" "--skip-children" "--quiet" "--emit" "stdout"))
          (terraform . ("terraform" "fmt" "-"))
          (zprint "zprint" "{:search-config? true}")))
  (apheleia-global-mode t))

(defun magit-status-fullscreen (prefix)
  (interactive "P")
  (magit-status)
  (unless prefix
    (delete-other-windows)))

  ; (winner-mode 1) ;; winner-mode remembers the window configurations, allowing you to easily switch back to previous configurations.

  ; (defun magit-fullscreen ()
  ;   "Open Magit status in a full window and remember previous configuration."
  ;   (interactive)
  ;   (delete-other-windows)
  ;   (magit-status-setup-buffer)
  ;   (add-hook 'magit-mode-quit-window-hook 'winner-undo nil t))

(defun move-tab-forward ()
  (interactive)
  (tab-bar-move-tab 1))
(defun move-tab-backward ()
  (interactive)
  (tab-bar-move-tab -1))

(defun kill-all-buffers-and-tab ()
  "Kill all buffers in the current tab and close the tab."
  (interactive)
  (let ((current-tab (tab-bar--current-tab)))
    ;; Kill all buffers associated with this tab's windows
    (dolist (win (cdr (assq 'windows current-tab)))
      (let ((buf (window-buffer win)))
        (when (buffer-live-p buf)
          (kill-buffer buf))))
    ;; Close the tab
    (tab-bar-close-tab)))

(defun open-config ()
  (interactive)
  (find-file "~/.config/emacs/config.org"))

(use-package general
  :after evil
  :config
  (general-evil-setup)

  (general-define-key
     :states 'normal
     :keymaps 'override
     "f" '(execute-extended-command :wk "Execute command")
     "." '(find-file :wk "Find in current dir")
     "§ §" '(switch-to-buffer :wk "Switch buffer")
     ;;"TAB TAB" 'switch-to-buffer ;; breaks magit
     "g d" 'lsp-find-definition
     "g D" 'lsp-ui-peek-find-definitions
     "g r" 'lsp-find-references
     "g c" 'comment-line
     "g R" 'lsp-rename
     ;; TODO Add focusing on the doc frame
     "K"  'lsp-ui-doc-glance
     "C-k" 'lsp-ui-doc-focus-frame)

  (general-create-definer cl/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  (cl/leader-keys
    "SPC"  '(project-find-file :wk "Search")
    "c"    'kill-this-buffer)

  (general-unbind 'magit-mode-map "M-1" "M-2" "M-3" "M-4" "M-5" "M-6" "M-7" "M-8" "M-9")

  (general-def
    :keymaps 'magit-mode-map
    "f" nil
    "M-f" 'magit-fetch)

  ;; (cl/leader-keys
  ;;   "p" '(projectile-command-map :wk "projectile"))

  (cl/leader-keys
    "g" '(:ignore :wk "lsp + magit")
    "g d" '(lsp-find-definition :wk "Go to definition")
    "g r" '(lsp-ui-peek-find-references :wk "Go to references") 
    "g c" '(comment-line :wk "Comment line(s)")
    "g e" '(lsp-rename :wk "Rename")
    "g g" '(magit-status :wk "Show magit status"))

  (cl/leader-keys
    "m" '(:ignore :wk "multicursors")
    "m a" '(evil-mc-make-all-cursors :wk "Add cursors to all")
    "m c" '(evil-mc-undo-all-cursors :wk "Undo all cursors")
    "m m" '(evil-mc-make-and-goto-next-match :wk "Add cursor and go to next")
    "m u" '(evil-mc-undo-last-added-cursor :wk "Undo cursor")
    "m s" '(evil-mc-skip-and-goto-next-match :wk "Skip cursor and go to next")
    "m p" '(evil-mc-pause-cursors :wk "Pause cursors")
    "m r" '(evil-mc-resume-cursors :wk "Resume cursors"))

  (cl/leader-keys
    "e"  '(:ignore t :wk "evaluate")
    ;; elisp
    "e l"  '(:ignore t :wk "elisp (configs)")
    "e l b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e l d" '(eval-defun :wk "Evaluate elisp defun")
    "e l r" '(eval-region :wk "Evaluate elisp in region")

    ;; status-mobile
    "e s"   '(:ignore t :wk "status-mobile")
    "e s i" '((lambda () (interactive) (project-detached-shell-command "make run-ios" status-ios-buffer)) :wk "Run ios")
    "e s I" '((lambda () (interactive) (project-detached-shell-command "open -a Simulator.app" status-ios-buffer)) :wk "Open ios simulator")
    "e s a" '((lambda () (interactive) (project-detached-shell-command "adb reverse tcp:8081 tcp:8081; make run-android & emulator -avd Pixel_6_API_34" status-android-buffer)) :wk "Run android (emulator)")
    "e s A" '((lambda () (interactive) (project-detached-shell-command "adb reverse tcp:8081 tcp:8081; make run-android" status-android-buffer)) :wk "Run android (device)")
    "e s c" '((lambda () (interactive) (project-detached-shell-command "make run-clojure" status-clojure-buffer)) :wk "Run shadow-cljs")
    "e s m" '((lambda () (interactive) (project-detached-shell-command "make run-metro" status-metro-buffer)) :wk "Run metro"))

  (cl/leader-keys
    "f"   '(:ignore t :wk "find")
    "f ." '(find-file :wk "Find current dir")
    "f f" '(consult-ripgrep :wk "Find by word")
    "f F" '((lambda () (interactive) (consult-ripgrep default-directory)) :wk "Find by word")
    "f c" '(u/consult-ripgrep-symbol-at-point :wk "Find at cursor")
    "f r" '(consult-recent-file :wk "Find recent"))

  (cl/leader-keys
    "o"  '(:ignore t :wk "open")
    "o t" '(project-eshell :wk "Open term")
    "o T" '(eshell-here :wk "Open term here")
    "o h" '(dashboard-open :wk "Open home dashboard"))

  (cl/leader-keys
    "h"  '(:ignore t :wk "help")
    "h f" '(describe-function :wk "Describe function")
    "h v" '(describe-variable :wk "Describe variable")
    "h c"  '(open-config :wk "Open config")
    "h r"  '((lambda () (interactive) (load-file "~/.config/emacs/init.el")) :wk "Reload config"))

  (cl/leader-keys
    "w" '(:ignore t :wk "windows")
    "w c" '(evil-window-delete :wk "Close window")
    "w n" '(evil-window-new :wk "New window")
    "w s" '(evil-window-vsplit :wk "Vertical split window")
    "w S" '(evil-window-split :wk "Horizontal split window")
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")
    "w w" '(evil-window-next :wk "Goto next window"))

  (general-create-definer cl/buffer-leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "S-SPC"
    :global-prefix "M-S-SPC")

  (cl/buffer-leader-keys
    "S-SPC" '(project-switch-to-buffer :wk "Switch buffer")
    "SPC" '(consult-buffer-other-window :wk "Switch buffer split")
    "a" '(switch-to-buffer :wk "Switch buffer (all)")
    "c" '(kill-this-buffer :wk "Kill this buffer")
    "n" '(next-buffer :wk "Next buffer")
    "p" '(previous-buffer :wk "Previous buffer")
    "r" '(revert-buffer :wk "Reload buffer"))

  (cl/leader-keys
    "t"  '(:ignore t :wk "tabs")
    "t s" '(burly-bookmark-windows :wk "Save tab bookmark")
    "t o" '(burly-open-bookmark :wk "Open tab bookmark")
    "t n" '(tab-bar-new-tab :wk "New tab")
    "t c" '(tab-bar-close-tab :wk "Close tab")
    "t k" '(kill-all-buffers-and-tab :wk "KILL tab")
    "t r" '(tab-bar-rename-tab :wk "Rename tab")
    "t f" '(move-tab-forward :wk "Move tab forward")
    "t b" '(move-tab-backward :wk "Move tab backward")
    "t u" '(tab-bar-undo-close-tab :wk "Undo tab"))

  ;;TODO maybe doesn't have to be clj specific??
  (general-create-definer cl/clj-keys
    :states '(normal insert visual emacs)
    :keymaps 'clojure-mode-map 
    :prefix ","
    :global-prefix "M-,")

  (cl/clj-keys 
    "x" '(sp-kill-whole-line :wk "Remove whole line")
    "c" '(sp-kill-sexp :wk "Remove sexp"))

  (cl/clj-keys
    "e"  '(:ignore t :wk "evaluate")
    "e b" '(cider-eval-buffer :wk "REPL eval buffer")
    "e c" '(cider-pprint-eval-last-sexp-to-comment :wk "REPL eval to comment")
    "e f" '(cider-eval-defun-at-point :wk "REPL eval defun")
    "e r" '(cider-pprint-eval-last-sexp-to-repl :wk "REPL eval to repl")
    "e e" '(cider-eval-list-at-point :wk "REPL eval around"))

  (cl/clj-keys
    "r"  '(:ignore t :wk "repl")
    "rr" '(cider-connect-cljs :wk "REPL at point")))

;;(use-package nano-theme)
  ;;(nano-light))

;; (use-package nano-modeline)
;; (add-hook 'prog-mode-hook            #'nano-modeline-prog-mode)
;; (add-hook 'text-mode-hook            #'nano-modeline-text-mode)
;; (add-hook 'org-mode-hook             #'nano-modeline-org-mode)

(set-face-attribute 'default nil
  :font "JetBrains Mono"
  :height 160
  :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono-16"))

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(add-to-list 'default-frame-alist '(undecorated . t))

(global-display-line-numbers-mode 1)
;;(global-visual-line-mode 1)
;;(setq-default word-wrap t)
;;(toggle-truncate-lines -1)
(setq-default truncate-lines t)
(setq-default global-visual-line-mode t)
(visual-line-mode)
;;(setq truncate-partial-width-windows t)

(use-package rainbow-mode
  :hook 
  ((org-mode prog-mode) . rainbow-mode))

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))
(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(electric-indent-mode -1) ;; removes weird indentiation is source blocks
(setq org-edit-src-content-indentation 0)
(setq org-return-follows-link t)

(require 'org-tempo)

;;(use-package org-projectile
;; ;;:bind (("C-c n p" . org-project-capture-project-todo-completing-read))
;; :ensure t
;; :config
;; (progn
;;   (setq org-project-capture-projects-file "~/org/projects.org")
;;   (org-project-capture-single-file)))
