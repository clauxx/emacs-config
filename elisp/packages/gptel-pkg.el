(use-package gptel
  :config
  (setq
   ;;gptel-default-mode 'org-mode ;; not very stable
   gptel-model "claude-3-sonnet-20240229" ;  "claude-3-opus-20240229" also available
   gptel-backend (gptel-make-anthropic "Claude"
                   :stream t
		   :key (getenv "CLAUDE_TOKEN"))))

(defun cl/gptel-send-as-comment ()
  "Send PROMPT to the Claude AI and insert the result as a comment.
The comment syntax will depend on the current major mode."
  (interactive)
  (let* ((result (gptel-send))
         (comment-start (cl/get-comment-start-string major-mode)))
    (save-excursion
      (goto-char (point-max))
      (insert "\n" comment-start " " result "\n" comment-start " End of AI response"))))

(defun cl/get-comment-start-string (mode)
  "Return the comment start string for the given major MODE."
  (pcase mode
    ('emacs-lisp-mode ";;")
    ('python-mode "#")
    ('js-mode "//")
    ('java-mode "//")
    ('c++-mode "//")
    ('c-mode "/*")
    (_ ";;")))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "h"  '(:ignore t :wk "AI Chat (Claude)")
   "h o" '(gptel :wk "Open chat")
   "h a" '(gptel-add :wk "Add region to context")
   "h f" '(gptel-add-file :wk "Add file to context")
   "h s" '(cl/gptel-send-as-comment :wk "Send region")))

(with-eval-after-load 'general
  (general-define-key
   :states 'normal
   :keymaps 'gptel-mode-map
   "M-RET" 'gptel-send))


(provide 'gptel-pkg)

;; 
;; 
;; 
