;; Start
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)


;; configure elpy
(elpy-enable)

;; py3
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")

;; ace-window to switch windows fast
(global-set-key (kbd "M-p") 'ace-window)

;;bash autocomplete
(autoload 'bash-completion-dynamic-complete 
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
	  'bash-completion-dynamic-complete)

;; scala enable
(use-package scala-mode :interpreter ("scala" . scala-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ocaml
(load "/home/suraj/.opam/system/share/emacs/site-lisp/tuareg-site-file")
(setq tuareg-indent-align-with-first-arg nil)
(add-hook
 'tuareg-mode-hook
 (lambda()
   (setq show-trailing-whitespace t)
   (setq indicate-empty-lines t)

   ;; Enable the representation of some keywords using fonts
   (when (functionp 'prettify-symbols-mode)
     (prettify-symbols-mode))

   (when (functionp 'flyspell-prog-mode)
     (flyspell-prog-mode))
   ;; See README
   ;;(setq tuareg-match-patterns-aligned t)
   ;;(electric-indent-mode 0)
   ))


;; Easy keys to navigate errors after compilation:
(define-key tuareg-mode-map [(f12)] 'next-error)
(define-key tuareg-mode-map [(shift f12)] 'previous-error)


;; Use Merlin if available
(when (require 'merlin nil t)
  (setq merlin-command 'opam)
  (add-to-list 'auto-mode-alist '("/\\.merlin\\'" . conf-mode))

  (when (functionp 'merlin-document)
    (define-key tuareg-mode-map (kbd "\C-c\C-h") 'merlin-document))

  ;; Run Merlin if a .merlin file in the parent dirs is detected
  (add-hook 'tuareg-mode-hook
            (lambda()
              (let ((fn (buffer-file-name)))
                (if (and fn (locate-dominating-file fn ".merlin"))
                    (merlin-mode))))))

;; Choose modes for related config. files
(setq auto-mode-alist
      (append '(("_oasis\\'" . conf-mode)
		("_tags\\'" . conf-mode)
		("_log\\'" . conf-mode))
	      auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company
(require 'company)

;; keybindings for company mode
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
