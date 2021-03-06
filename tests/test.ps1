#require version 3

$path   = Split-Path   (Resolve-Path $MyInvocation.InvocationName)
$script = Resolve-Path (join-path $path ..\core\InvokeParseScript.ps1)

. $script

$testScript = @'
function test {
    function x {
    }
}
'@

$r = Invoke-ParseScript $testScript

function LookupColor ($kind) {
    switch ($kind) {
        'Identifier' {'Red'}
        default      {'default'}
    }
}

function TagStuff {
    param(
        [Parameter(ValueFromPipeline)]
        $Token
    )

    Process {
        $token |
            add-member -passthru NoteProperty Color (LookupColor $Token.Kind)
    }
}

$ast  = $r.ast
$text = $r.ast.Extent.Text
$list = $r.ListOfTokens | TagStuff 