const version = "0.0.0"
type option struct {
	version bool
}
var opt option
func init() {
	flag.BoolVar(&opt.version, "version", false, "")
}
