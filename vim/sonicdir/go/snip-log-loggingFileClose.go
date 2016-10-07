func loggingFileClose(at string, f interface {
	Close() error
}) {
	if err := f.Close(); err != nil {
		log.Printf("%s:%v", at, err)
	}
}
