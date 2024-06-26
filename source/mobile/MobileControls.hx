package mobile;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;

/**
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class MobileControls extends FlxSpriteGroup
{
	public static var customVirtualPad(get, set):FlxVirtualPad;
	public static var mode(get, set):String;

	public var virtualPad:FlxVirtualPad;
	public var hitbox:FlxHitbox;

	public function new()
	{
		super();

		switch (MobileControls.mode)
		{
			case 'Pad-Right':
				hitbox = FlxDestroyUtil.destroy(hitbox);
				hitbox = null;
				virtualPad = new FlxVirtualPad(RIGHT_FULL, B);
				add(virtualPad);			
			case 'Pad-Left':
				hitbox = FlxDestroyUtil.destroy(hitbox);
				hitbox = null;
				virtualPad = new FlxVirtualPad(LEFT_FULL, B);
				add(virtualPad);
			case 'Pad-Custom':
				hitbox = FlxDestroyUtil.destroy(hitbox);
				hitbox = null;
				virtualPad = MobileControls.customVirtualPad;
				add(virtualPad);
			case 'Pad-Duo':
				hitbox = FlxDestroyUtil.destroy(hitbox);
				hitbox = null;
				virtualPad = new FlxVirtualPad(BOTH_FULL, B);
				add(virtualPad);
			case 'Hitbox':
				hitbox = FlxDestroyUtil.destroy(hitbox);
				hitbox = null;
				virtualPad = new FlxVirtualPad(NONE, B);
				add(virtualPad);
				hitbox = new FlxHitbox(false);
				add(hitbox);
			case 'HitboxAlt':
				virtualPad = FlxDestroyUtil.destroy(virtualPad);
				virtualPad = null;
				hitbox = new FlxHitbox(true);
				add(hitbox);
			case 'Keyboard': // do nothing
		}	
	}

	override public function destroy():Void
	{
		super.destroy();

		if (virtualPad != null)
		{
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
			virtualPad = null;
		}

		if (hitbox != null)
		{
			hitbox = FlxDestroyUtil.destroy(hitbox);
			hitbox = null;
		}
	}

	private static function get_mode():String
	{
		if (FlxG.save.data.controlsMode == null)
		{
			FlxG.save.data.controlsMode = 'Pad-Right';
			FlxG.save.flush();
		}

		return FlxG.save.data.controlsMode;
	}

	private static function set_mode(mode:String = 'Pad-Right'):String
	{
		FlxG.save.data.controlsMode = mode;
		FlxG.save.flush();

		return mode;
	}

	private static function get_customVirtualPad():FlxVirtualPad
	{
		var virtualPad:FlxVirtualPad = new FlxVirtualPad(RIGHT_FULL, B);
		if (FlxG.save.data.buttons == null)
			return virtualPad;

		var tempCount:Int = 0;
		for (buttons in virtualPad)
		{
			buttons.x = FlxG.save.data.buttons[tempCount].x;
			buttons.y = FlxG.save.data.buttons[tempCount].y;
			tempCount++;
		}

		return virtualPad;
	}

	private static function set_customVirtualPad(virtualPad:FlxVirtualPad):FlxVirtualPad
	{
		if (FlxG.save.data.buttons == null)
		{
			FlxG.save.data.buttons = new Array();
			for (buttons in virtualPad)
			{
				FlxG.save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
				FlxG.save.flush();
			}
		}
		else
		{
			var tempCount:Int = 0;
			for (buttons in virtualPad)
			{
				FlxG.save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				FlxG.save.flush();
				tempCount++;
			}
		}

		return virtualPad;
	}
}
