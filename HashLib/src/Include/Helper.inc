{ *********************************************************** }
{ *                     HashLib Library                     * }
{ *       Copyright (c) Ugochukwu Mmaduekwe 2016            * }
{ *********************************************************** }

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)

{$MACRO ON}
// FPC 3.0.0 and Above
// Had to Include this here since Delphi does not allow it Compile in "HashLib.inc".
{$IF FPC_FULLVERSION < 30000}
{$MESSAGE ERROR 'This Library requires FreePascal 3.0.0 or higher.'}
{$IFEND}
