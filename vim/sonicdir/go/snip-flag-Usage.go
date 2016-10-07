// flag.Usage = usage
func usage() {
	fmt.Fprintf(os.Stderr, "Usage of %s:\n", os.Args[0])
	// TODO: Add description
	fmt.Fprintf(os.Stderr, `
Description
`)
	fmt.Fprintf(os.Stderr, `
ALL FLAGS
`)
	flag.PrintDefaults()
	os.Exit(1)
}
