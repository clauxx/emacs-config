(use-package tabspaces
  :hook (after-init . tabspaces-mode)
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*"))
  (tabspaces-initialize-project-with-todo t)
  (tabspaces-todo-file-name "project-todo.org")
  ;; sessions
  (tabspaces-session t)
  (tabspaces-session-auto-restore t)
  :config)

(defun tab-bar-tab-name-format-default (tab i)
  (let ((current-p (eq (car tab) 'current-tab))
        (tab-num (if (and tab-bar-tab-hints (< i 10))
                     (format "%d" i) "")))
    (propertize
     (concat "  "  tab-num " " (alist-get 'name tab) " ")
     'face (funcall tab-bar-tab-face-function tab))))

(setq tab-bar-tab-name-format-function #'tab-bar-tab-name-format-default)
(setq tab-bar-close-button-show nil)          ;; hide tab close / X button
(setq tab-bar-new-tab-choice "*dashboard*")   ;; buffer to show in new tabs
(setq tab-bar-tab-hints t)                    ;; show tab numbers
(setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
(setq tab-bar-select-tab-modifiers '(meta))

(set-face-attribute 'tab-bar nil
                    :height 120
                    :box '(:line-width 8 :color "#000")
                    :background "#000"
                    :foreground "#B5B2C2")

(set-face-attribute 'tab-bar-tab nil
                    :family (face-attribute 'default :family)
                    :weight 'bold
                    :box '(:line-width 12 :color "#000")
                    :background "#5A7D7C"
                    :foreground "#f1f1f1")

(set-face-attribute 'tab-bar-tab-inactive nil
                    :family (face-attribute 'default :family)
                    :slant 'italic
                    :weight 'normal
                    :background "#B5B2C2"
                    :foreground "#37474F")

(with-eval-after-load 'consult
  ;; assure tabspaces--local-buffer-p is not void when there are no tabs
  (when (fboundp 'tabspaces--local-buffer-p)
    ;; hide full buffer list (still available with "b" prefix)
    (consult-customize consult--source-buffer :hidden t :default nil)
    ;; set consult-workspace buffer list
    (defvar consult--source-workspace
      (list :name     "Workspace Buffers"
            :narrow   ?w
            :history  'buffer-name-history
            :category 'buffer
            :state    #'consult--buffer-state
            :default  t
            :items    (lambda () (consult--buffer-query
				  :predicate #'tabspaces--local-buffer-p
				  :sort 'visibility
				  :as #'buffer-name)))
      "Set workspace buffer list for consult-buffer.")
    (add-to-list 'consult-buffer-sources 'consult--source-workspace)))

(defun cl/move-tab-forward ()
  (interactive)
  (tab-bar-move-tab 1))

(defun cl/move-tab-backward ()
  (interactive)
  (tab-bar-move-tab -1))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "t" '(:ignore t :wk "Tabspaces")
   "t c" '(tabspaces-clear-buffers :wk "Clear tab buffers")
   "t x" '(tabspaces-kill-buffers-close-workspace :wk "Close tab and buffers")
   "t p" '(tabspaces-open-or-create-project-and-workspace :wk "Open project in tab")
   "t l" '(cl/move-tab-forward :wk "Move tab forward")
   "t h" '(cl/move-tab-backward :wk "Move tab backward")
   "t t" '(tabspaces-switch-or-create-workspace :wk "Switch/create tab")))

(provide 'tabspaces-pkg)
