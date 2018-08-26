(in-package :nlgame)


(defvar *main-window* nil)              ; The main `sdl2' window
(defvar *main-running-p* nil)           ; Whether the game is currently running


(defun main-run (&key (x :centered) (y :centered) (w 800) (h 600))
  ;; Don't try again if already running
  (if *main-running-p*
      (error "already running")
      (let ((*main-running-p* t))

        ;; Initialize SDL
        (sdl2:make-this-thread-main
         (lambda ()
           (sdl2:with-init (:everything)

             ;; Create window
             (sdl2:with-window (*main-window* :title "nlgame"
                                              :x x :y y :w w :h h
                                              :flags '(:shown :opengl))

               ;; Make `cl-opengl' use `sdl2'
               (setf cl-opengl-bindings:*gl-get-proc-address* #'sdl2::gl-get-proc-address)

               ;; Use OpenGL core profile
               (sdl2:gl-set-attr :context-major-version 3)
               (sdl2:gl-set-attr :context-minor-version 2)
               (sdl2:gl-set-attr :context-profile-mask sdl2-ffi::+sdl-gl-context-profile-core+)

               ;; Create OpenGL context
               (sdl2:with-gl-context (gl-context *main-window*)

                 ;; Run main event loop, forwarding events to relevant `main-' functions
                 (main-load)
                 (sdl2:with-event-loop (:method :poll)
                   (:quit ()
                          t)
                   (:idle ()
                          (repl-update)
                          (repl-continuable
                            (main-update)
                            (main-draw))
                          (finish-output))
                   (:keydown () (format t "keydown~%"))
                   (:keyup () (format t "keyup~%"))
                   (:mousebuttondown () (format t "mousebuttondown~%"))
                   (:mousebuttonup () (format t "mousebuttonup~%"))
                   (:mousemotion () (format t "mousemotion~%"))
                   (:mousewheel () (format t "mousewheel~%"))
                   (:textediting () (format t "textediting~%"))
                   (:textinput () (format t "textinput~%")))
                 (main-unload)))))))))


(defun main-load ()
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (gl:disable :depth-test)
  (gl:clear-color 0 0 0 1))

(defun main-unload ()
  )


(defun main-update ()
  )


(defun main-draw ()
  (gl:clear :color-buffer-bit)


  (gl:flush)
  (sdl2:gl-swap-window *main-window*))
