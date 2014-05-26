use ExtUtils::MakeMaker;


WriteMakefile(
    NAME => 'Protoview',
    VERSION_FROM => 'lib/Protoview/VARS.pm',
    EXE_FILES => ['scripts/protoview'],
    MAN1PODS => {
	'lib/Protoview/doc.pod' => 'blib/man1/protoview.1',
    },
    MAN3PODS => {},
    LICENSE  => 'GPLv3'
    );
