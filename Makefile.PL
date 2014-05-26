use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'Protoview',
    VERSION_FROM => 'lib/Protoview/VARS.pm',
    EXE_FILES => ['scripts/protoview']
    );
