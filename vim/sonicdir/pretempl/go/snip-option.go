const version = "0.0.0"
type option struct {
	version bool
}
var opt option
func(opt *option) init() {
	flag.BoolVar(&opt.version, "version", false, "")
	flag.Parse()
	if flag.NArg() != 0 {
		log.Fatal("invalid argument:", flag.Args())
	}
	if opt.version {
		fmt.Printf("version %s\n", version)
		os.Exit(0)
	}
}
