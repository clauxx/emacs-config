;; (tab-bar-show t)
;; (tab-bar-close-button-show t)
;; (tab-bar-new-tab-choice "*dashboard*")
;; (tab-bar-tab-hints t)
;; (tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
;; (tab-bar-select-tab-modifiers '(meta))

(setq tab-bar-show t)                         ;; hide bar if <= 1 tabs open
(setq tab-bar-close-button-show nil)          ;; hide tab close / X button
(setq tab-bar-new-tab-choice "*dashboard*")   ;; buffer to show in new tabs
(setq tab-bar-tab-hints t)                    ;; show tab numbers
(setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
(setq tab-bar-select-tab-modifiers '(meta))
;; (tab-bar-show t ;; hide bar if <= 1 tabs open
;;  tab-bar-close-button-show nil
;;  tab-bar-new-tab-choice "*dashboard*"
;;  tab-bar-tab-hints t
;;  tab-bar-format '(tab-bar-format-tabs tab-bar-separator)
;;  tab-bar-select-tab-modifiers '(meta))

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

(defun cl/move-tab-forward ()
  (interactive)
  (tab-bar-move-tab 1))

(defun cl/move-tab-backward ()
  (interactive)
  (tab-bar-move-tab -1))

(defun cl/kill-all-buffers-and-tab ()
  "Kill all buffers in the current tab and close the tab."
  (interactive)
  (let ((current-tab (tab-bar--current-tab)))
    (dolist (win (cdr (assq 'windows current-tab)))
      (let ((buf (window-buffer win)))
        (when (buffer-live-p buf)
          (kill-buffer buf))))
    (tab-bar-close-tab)))

(defun cl/format-tab-name (tab i)
  (let ((current-p (eq (car tab) 'current-tab))
        (tab-num (if (and tab-bar-tab-hints (< i 10))
                     (format "%d" i) "")))
    (propertize
     (concat "  "  tab-num " " (alist-get 'name tab) " ")
     'face (funcall tab-bar-tab-face-function tab))))

(setq tab-bar-tab-name-format-function #'format-tab-name)

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "t"   '(:ignore t :wk "tabs")
   "t n" '(tab-bar-new-tab :wk "New tab")
   "t c" '(tab-bar-close-tab :wk "Close tab")
   "t r" '(tab-bar-rename-tab :wk "Rename tab")
   "t u" '(tab-bar-undo-close-tab :wk "Undo tab")
   "t f" '(cl/move-tab-forward :wk "Move tab forward")
   "t b" '(cl/move-tab-backward :wk "Move tab backward")
   "t k" '(cl/kill-all-buffers-and-tab :wk "KILL tab")))

(provide 'tabs-config)
