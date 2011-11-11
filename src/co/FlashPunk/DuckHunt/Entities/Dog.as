package co.FlashPunk.DuckHunt.Entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	
	public class Dog extends Entity
	{
		[Embed(source = 'assets/sprites/dog_.png')]
		private const DOG:Class;
		private static var SPRITEWIDTH:Number = 60;
		private static var SPRITEHEIGHT:Number = 61;
		
		public var Scale:Number = 2;
		public var Speed:Number = 0.5;
		private var _TimePassed:Number = 0;
		
		public var DogSprite:Spritemap = new Spritemap(DOG, 59, 52);
		
		public function Dog()
		{
			DogSprite.add( 'walk', [0, 1, 2, 3, 4], 3, true );
			DogSprite.add( 'yay_got_them', [5, 6, 7], 1, false );
			DogSprite.scale = this.Scale;
			//DogSprite.add( 'got_one', [8], 1, true );
			//DogSprite.add( 'got_both', [9], 1, true );
			//DogSprite.add( 'laugh', [10,11], 2, true );
			graphic = DogSprite;
			DogSprite.play( 'walk' );
		}
		
		override public function update():void
		{
			_TimePassed += FP.elapsed;
			switch( DogSprite.currentAnim){
				case 'walk':
					if( _TimePassed >= 6 )
					{
						_TimePassed = 0;
						DogSprite.play( 'yay_got_them' );
					}
					break;
				case 'yay_got_them':
					if( _TimePassed >= 2 )
					{
						_TimePassed = 0;
						this.active = false;
					}
					break;
			}
			this.x += this.Speed;	
		}		
	}
}