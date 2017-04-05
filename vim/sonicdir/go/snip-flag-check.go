// Checking after persing flags
func argsCheck() {
	if len(flag.Args()) != 0 {
		fmt.Printf("cmd = %v\n", os.Args)
		fmt.Println("-----| Unknown option |-----")
		for _, x := range flag.Args() {
			fmt.Println(x)
		}
		fmt.Println("-----| Usage |-----")
		flag.PrintDefaults()
		os.Exit(1)
	}
}
