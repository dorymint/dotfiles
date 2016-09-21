// Directory crawl model
func Crawl(/*TODO*/) (/*TODO*/) {
	mux := new(sync.Mutex)
	wg := new(sync.WaitGroup)

	var crawl func(/*TODO*/)
	crawl = func(/*TODO*/) {
		defer wg.Done()
		for {
			/*
			wg.Add(1)
			go crawl(TODO)
			*/
		}
	}

	/*
	wg.Add(1)
	dirsCrawl(TODO)
	wg.Wait()
	*/
	// or return function
	/* return crawl */
}

