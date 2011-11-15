package co.FlashPunk.DuckHunt.Entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	public class Crosshair extends Entity
	{
		[Embed(source = 'assets/sprites/crosshair.png')]
		private const CROSSHAIR:Class;
		
		[Embed(source = 'assets/sounds/fire.mp3')]
		private const FIRE:Class;
		
		
		private static var SPRITEWIDTH:Number = 29;
		private static var SPRITEHEIGHT:Number = 29;
		
		private var Scale:Number = 1;
		
		private var CrosshairSprite:Spritemap = new Spritemap(CROSSHAIR, SPRITEWIDTH, SPRITEHEIGHT);
		private var FireSound:Sfx = new Sfx(FIRE);
		
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
			
			var hitBoxWidth:Number = SPRITEWIDTH * (this.Scale / 2);
			var hitBoxHeight:Number = SPRITEHEIGHT * (this.Scale / 2);
			var hitBoxCenter_x:Number = SPRITEWIDTH * (this.Scale / 2) - (hitBoxWidth /2 );
			var hitBoxCenter_y:Number = SPRITEHEIGHT * (this.Scale / 2) - (hitBoxHeight / 2)
			
			setHitbox(hitBoxWidth, hitBoxHeight, hitBoxCenter_x, hitBoxCenter_y);
			//setHitbox(SPRITEWIDTH, SPRITEHEIGHT);
			trace('CH:'+ hitBoxCenter_x + ' CV: ' + hitBoxCenter_y)
		}
		
		override public function update():void
		{
			
			try{
				if(Input.mousePressed)
				{
					FireSound.play();
				}
				this.x = Input.mouseX;
				this.y = Input.mouseY;
			}
			catch (error:Error)
			{
				
			}
		}
	}
}