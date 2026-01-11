# 使用 File::Basename 以便处理路径
use File::Basename;

# 1. 目录设置
$out_dir = 'output';
$aux_dir = 'build';

# 2. 编译引擎设置
$pdf_mode = 5; # 5 表示使用 xelatex 生成 pdf
$xelatex = 'xelatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S';

# 3. 参考文献引擎 (如果你的论文使用 biber)
$bibtex = 'biber';

# 4. 索引与术语表
$makeindex = 'upmendex -s mystyle.ist %O -o %D %S';

# 自定义术语表依赖关系
add_cus_dep('glo', 'gls', 0, 'makeglossaries');
add_cus_dep('acn', 'acr', 0, 'makeglossaries');

sub makeglossaries {
    my ($base_name, $path) = fileparse($_[0], qr/\.[^.]*/);
    my $cmd = "makeglossaries";
    if ($path) {
        $cmd .= " -d \"$path\"";
    }
    $cmd .= " \"$base_name\"";
    return system($cmd);
}

# 5. 清理设置：告诉 latexmk 哪些文件属于临时文件，清理时一并删掉
push @generated_exts, 'glo', 'gls', 'glg', 'acn', 'acr', 'alg';