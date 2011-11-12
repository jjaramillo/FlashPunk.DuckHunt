package co.FlashPunk.DuckHunt.Entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	public class Crosshair extends Entity
	{
		[Embed(source = 'assets/sprites/crosshair.png')]
		private const CROSSHAIR:Class;
		private static var SPRITEWIDTH:Number = 29;
		private static var SPRITEHEIGHT:Number = 29;
		
		private var Scale:Number = 1;
		
		public var CrosshairSprite:Spritemap = new Spritemap(CROSSHAIR, SPRITEWIDTH, SPRITEHEIGHT);
		
		public function Crosshair()
		{
			type = 'Crosshair';
			CrosshairSprite.scale = this.Scale;
			CrosshairSprite.add( 'normal', [0], 1, false );
			CrosshairSprite.add( 'predator', [1], 8, false );			
			CrosshairSprite.add( 'crucifix', [2], 2, false );
			
			graphic = CrosshairSprite;
			CrosshairSprite.play('normal');	
			Input.mouseCursor = 'hide';
			
			setHitbox(SPRITEWIDTH * this.Scale, 
				SPRITEHEIGHT * this.Scale);
		}
		
		override public function update():void
		{
			try{	
				this.x = Input.mouseX;
				this.y = Input.mouseY;
			}
			catch (error:Error)
			{
				
			}
		}
	}
}