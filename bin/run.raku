#!/usr/bin/env raku
use JSON::Fast;

unit sub MAIN (
       Str:D  $slug,          #= exercise-slug
    IO(Str:D) $solution-path, #= /absolute/path/to/exercise-slug/solution/folder/
    IO(Str:D) $output-path,   #= /absolute/path/to/output/directory/
);

$output-path.mkdir unless $output-path.d;

say "$slug: creating representation...";

my $ast = $solution-path\
    .add(<.meta config.json>)\
    .slurp\
    .&from-json<files><solution>
    .map({$solution-path.add($_).slurp.AST.raku})
    .join("\n\n"); 

my %mapping = $ast
    .lines
    .map({.match(/name \s+ .*? (\".*?\")/)[0] andthen .Str orelse Empty})
    .unique
    .pairs
    .map({'PLACEHOLDER%03d'.sprintf(.key) => .value});

for (
    'mapping.json'       => %mapping.&to-json(:sorted-keys),
    'representation.txt' => $ast.trans(%mapping.values => %mapping.keys),
    'representation.json'=> {:version(1)}.&to-json(:sorted-keys),
) {
    $output-path.add(.key).spurt(.value ~ "\n");
}
