@default_files = ('demopaper.tex');
$pdflatex      = 'pdflatex -synctex=1';
$interaction   = "nonstopmode";

add_cus_dep("ods","csv",0,"ods2csv");

sub ods2csv {
    if($_[0] eq ""){
        return;
    }
    my $sourceods = "$_[0].ods";
    my $sourcecsv = "$_[0].csv";
    print "Processing $sourceods...\n";
    system("libreoffice --headless --convert-to csv \"".$sourceods."\" --outdir tables");
    system("python src/preprocess_csv.py \"".$sourcecsv."\"  --inplace");
    return;
}

# Make sure all the dependencies get build initially
#my @dep_files = ( 
#    "tables/demotable.csv"
#);
my @files = <tables/*.ods>;
my @dep_files = ();
foreach (@files) {
  @dep_files = (@dep_files, $_)
}

foreach (@dep_files) {
    print "$_\n";
    my ($filetype) = $_ =~ /^.*\.(.*)$/igs;
    print "Handle filetype $filetype...\n";
    my ($filename) = $_ =~ /^(.*)\..+/igs;
    print "Handle filename $filename...\n";

    if($filetype eq "ods"){
        if(-e $filename.".csv"){
        }else{
            print "$filename.csv does not exist. Create it initially.\n";
            #@_ = ($filename);
            ods2csv($filename);
        }
    }
}