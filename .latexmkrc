$pdflatex = "TEXINPUTS=.:build/: xelatex -interaction=nonstopmode --shell-escape -output-directory=build %O %S";
$pdf_mode = 1;
$dvi_mode = 0;
$postscript_mode = 0;
$out_dir = 'build';
$logfilewarninglist = 1;