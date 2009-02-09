;; set a color theme
(require 'color-theme)
(setq color-theme-is-global t)
(color-theme-initialize)
(color-theme-deep-blue)

;; Interactively Do Things
(require 'ido)
(ido-mode t)
     
;; Rinari mode for Rails Dev
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)

;; mode for editing erb files without mmm or mumamo
(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
          (lambda () (rinari-launch)))

(add-to-list 'load-path "/.emacs.d/haml-mode.el")
(require 'haml-mode nil 't)

; this allows us to have constant indentation as
; we progress in the code from line to line.
(defun create-newline-and-indent()
    (local-set-key [return] 'newline-and-indent))

(add-hook 'ruby-mode-hook 'create-newline-and-indent)
(add-hook 'php-mode-hook 'create-newline-and-indent)
(add-hook 'c-mode-hook 'create-newline-and-indent)


;; turns off word wrapping
(setq-default truncate-lines t)

;; turn off toolbar
(tool-bar-mode -1)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(setq-default indent-tabs-mode nil)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(setq c-default-style "bsd"
      c-basic-offset 2)

(setq tab-width 2)

;; functions to move forward and back a word, considering _ part of the word

(defun geosoft-forward-word ()
   ;; Move one word forward. Leave the pointer at start of word
   ;; instead of emacs default end of word. Treat _ as part of word
   (interactive)
   (forward-char 1)
   (backward-word 1)
   (forward-word 2)
   (backward-word 1)
   (backward-char 1)
   (cond ((looking-at "_") (forward-char 1) (geosoft-forward-word))
         (t (forward-char 1))))

(defun geosoft-backward-word ()
   ;; Move one word backward. Leave the pointer at start of word
   ;; Treat _ as part of word
   (interactive)
   (backward-word 1)
   (backward-char 1)
   (cond ((looking-at "_") (geosoft-backward-word))
         (t (forward-char 1))))


;; set Mac modifiers
(setq mac-option-modifier 'hyper) ; sets the Option key as Hyper
(setq mac-command-modifier 'meta) ; sets the Command key as Meta
(setq mac-control-modifier 'control) ; sets the Control key as Control ?

;; set option-left/right arrows to move forward/back a word

(global-set-key [H-right] 'geosoft-forward-word)
(global-set-key [H-left] 'geosoft-backward-word)

(global-set-key "\C-l" 'goto-line) ; [Ctrl]-[L]

(cua-mode t)  ;; oh damn if only there was a MUA moda

(add-to-list 'load-path "~/.emacs.d/weblogger")
(require 'weblogger)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(fringe-mode 0 nil (fringe))
 '(transient-mark-mode t)
 '(weblogger-config-alist (quote (("Loosely Typed" ("user" . "jcanady") ("server-url" . "http://innova-partners.com/blog/xmlrpc.php") ("weblog" . "1")) ("joncanady.com" ("user" . "jonc") ("server-url" . "http://joncanady.com/xmlrpc.php") ("weblog" . "1"))))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(require 'flymake-php)
(add-hook 'php-mode-user-hook 'flymake-php-laod)


;; Use "y or n" answers instead of full words "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Kills all them buffers except scratch
;; obtained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
          (buffer-list))
  (delete-other-windows))


(defun wrap-region (left right beg end)
  "Wrap the region in arbitrary text, LEFT goes to the left and RIGHT goes to the right."
  (interactive)
  (save-excursion
    (goto-char beg)
    (insert left)
    (goto-char (+ end (length left)))
    (insert right)))

(defmacro wrap-region-with-function (left right)
  "Returns a function which, when called, will interactively `wrap-region-or-insert' using LEFT and RIGHT."
  `(lambda () (interactive)
     (wrap-region-or-insert ,left ,right)))

(defun wrap-region-with-tag-or-insert ()
  (interactive)
  (if (and mark-active transient-mark-mode)
      (call-interactively 'wrap-region-with-tag)
    (insert "<")))

(defun wrap-region-with-tag (tag beg end)
  "Wrap the region in the given HTML/XML tag using `wrap-region'. If any
attributes are specified then they are only included in the opening tag."
  (interactive "*sTag (including attributes): \nr")
  (let* ((elems    (split-string tag " "))
         (tag-name (car elems))
         (right    (concat "</" tag-name ">")))
    (if (= 1 (length elems))
        (wrap-region (concat "<" tag-name ">") right beg end)
      (wrap-region (concat "<" tag ">") right beg end))))

(defun wrap-region-or-insert (left right)
  "Wrap the region with `wrap-region' if an active region is marked, otherwise insert LEFT at point."
  (interactive)
  (if (and mark-active transient-mark-mode)
      (wrap-region left right (region-beginning) (region-end))
    (insert left)))

(global-set-key "'"  (wrap-region-with-function "'" "'"))
(global-set-key "\"" (wrap-region-with-function "\"" "\""))
(global-set-key "`"  (wrap-region-with-function "`" "`"))
(global-set-key "("  (wrap-region-with-function "(" ")"))
(global-set-key "["  (wrap-region-with-function "[" "]"))
(global-set-key "{"  (wrap-region-with-function "{" "}"))
(global-set-key "<"  'wrap-region-with-tag-or-insert) ;; I opted not to have a wrap-with-angle-brackets

(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")

(defun dos-unix ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

;; indents the region iff mark is active,
;; otherwise indent the current line
(defun jpc-indent-region-or-line()
  (interactive)
  (if mark-active
      (indent-region (min (point) (mark))
                     (max (point) (mark))
                     nil)
    (indent-for-tab-command))
)

(add-hook 'c-mode-common-hook
          (function (lambda ()
                      (local-set-key (kbd "<tab>") 'jpc-indent-region-or-line)
                      )))


(add-hook 'javascript-mode-common-hook
          (function (lambda ()
                      (local-set-key (kbd "<tab>") 'jpc-indent-region-or-line)
                      )))

(setq rinari-tags-file-name "TAGS")

;; Make "Compilation" buffers always scroll with output
(setq compilation-scroll-output t)

;; scroll by one line
(setq scroll-step 1)

;; textmate mode is awesome
(add-to-list 'load-path "~/.emacs.d/textmate.el")
(require 'textmate)
(textmate-mode t)


(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                           'fullboth)))

(global-set-key "\M-\R" 'toggle-fullscreen)


;; Add color to a shell running in emacs 'M-x shell'
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; transparency
;; (set-frame-parameter nil 'alpha 90)

;; Command+s saves, Command+S saves as
(global-set-key [(meta s)] 'save-buffer)
(global-set-key [(meta S)] 'write-file)

;; colors in shell-mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on) 

;; speedbar needs to recognize PHP files
(speedbar)
(speedbar-add-supported-extension ".php") ; not necessarily required
(speedbar-add-supported-extension ".phtml") ; for Zend Views
(add-hook 'php-mode-user-hook 'semantic-default-java-setup)
(add-hook 'php-mode-user-hook
         (lambda ()
           (setq imenu-create-index-function
                 'semantic-create-imenu-index)
           ))