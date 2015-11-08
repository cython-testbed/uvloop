cdef class UVHandle:
    def __cinit__(self, Loop loop, *_):
        self.closed = 0
        self.handle = NULL
        self.loop = loop
        loop.__track_handle__(self)

    def __dealloc__(self):
        if self.handle is not NULL:
            if self.closed == 0:
                raise RuntimeError(
                    'Unable to deallocate handle for {!r} (not closed)'.format(
                        self))
            PyMem_Free(self.handle)
            self.handle = NULL

    cdef inline ensure_alive(self):
        if self.closed == 1:
            raise RuntimeError(
                'unable to perform operation on {!r}; '
                'the handler is closed'.format(self))

    cdef void close(self):
        if (self.closed == 1 or
            self.handle is NULL or
            self.handle.data is NULL or
            uv.uv_is_closing(self.handle)):
            return

        uv.uv_close(self.handle, cb_handle_close_cb) # void; no exceptions


cdef void cb_handle_close_cb(uv.uv_handle_t* handle) with gil:
    cdef UVHandle h = <UVHandle>handle.data
    h.closed = 1
    h.loop.__untrack_handle__(h) # void; no exceptions