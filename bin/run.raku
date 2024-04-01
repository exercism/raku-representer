#!/usr/bin/env raku
use JSON::Fast;

unit sub MAIN (
       Str:D  $slug,          #= exercise-slug
    IO(Str:D) $solution-path, #= /absolute/path/to/exercise-slug/solution/folder/
    IO(Str:D) $output-path,   #= /absolute/path/to/output/directory/
);

$output-path.mkdir unless $output-path.d;

say "$slug: creating representation...";

my $ast = $solution-path
    .add('lib')
    .dir
    .first({$slug.lc.subst('-').match(.extension('').basename.lc)})
    .slurp
    .AST
    .raku;

my %mappings = $ast
    .lines
    .map({.match(/name \s+ .*? (\".*?\")/)[0] andthen .Str orelse Empty})
    .unique
    .pairs
    .map({'PLACEHOLDER%03d'.sprintf(.key) => .value});

for (
    'mappings.json'      => %mappings.&to-json,
    'representation.txt' => $ast.trans(%mappings.values => %mappings.keys),
    'representation.json'=> {:version(1)}.&to-json,
) {
    $output-path.add(.key).spurt(.value ~ "\n");
}
