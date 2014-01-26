package com.furusystems.artillery;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author Andreas Rønning
 */
class Macros
{
	macro public static function getFileContent( fileName : Expr ) {
		Context.registerModuleDependency("com.furusystems.artillery.Macros", "D:/github/Barrage/test.brg");
        var fileStr = null;
        switch( fileName.expr ) {
        case EConst(c):
            switch( c ) {
            case CString(s): fileStr = s;
            default:
            }
        default:
        };
        if( fileStr == null )
            Context.error("Constant string expected",fileName.pos);
        return Context.makeExpr(sys.io.File.getContent(fileStr),fileName.pos);
    }
}