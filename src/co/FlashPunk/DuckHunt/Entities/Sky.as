package co.FlashPunk.DuckHunt.Entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	
	public class Sky extends Entity
	{
		[Embed(source = 'assets/sprites/sky.png')]
		private const SKY:Class;
		
		private var SkySprite:Spritemap = new Spritemap(SKY, 256, 224);
		private var Scale:Number = 3;
		
		public function Sky()
		{
			layer = 2;
			SkySprite.scale = this.Scale;
			SkySprite.add( 'blue', [0], 1, false);
			SkySprite.add( 'red', [1], 1, false);
			graphic = SkySprite;
			SkySprite.play( 'blue' );
			
		}
		
		public function changeSky(skyColor:String):void
		{
			SkySprite.play(skyColor);
		}
	}
}