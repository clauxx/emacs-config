(defvar font-name "JetBrains Mono")
(defvar font-size 12)

(set-face-attribute 'default nil
		    :font font-name
		    :height 120
		    :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
(set-face-attribute 'font-lock-comment-face nil
		    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
		    :slant 'italic)

(setq-default line-spacing 0.12)

(provide 'font)
