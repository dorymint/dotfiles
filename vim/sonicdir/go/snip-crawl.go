// Directory crawl model
func Crawl() {
	mux := new(sync.Mutex)
	wg := new(sync.WaitGroup)

	var crawl func()
	crawl = func() {
		defer wg.Done()
		for {
			/*
			wg.Add(1)
			go crawl()
			*/
		}
	}

	/*
	wg.Add(1)
	dirsCrawl()
	wg.Wait()

	return
	*/
	// or
	/* return crawl */
}

