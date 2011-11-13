package co.FlashPunk.DuckHunt.Entities
{
	import co.FlashPunk.DuckHunt.Stages.MainStage;
	
	import flash.utils.setTimeout;
	
	import flashx.textLayout.formats.Direction;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	
	public class Dog extends Entity
	{
		[Embed(source = 'assets/sprites/dog.png')]
		private const DOG:Class;	
		private const MAX_SNIFF_COUNT:Number = 3;
		
		public static var SPRITEWIDTH:Number = 60;
		public static var SPRITEHEIGHT:Number = 61;
		
		private var Scale:Number = 3;
		private var Speed:Number = 0.75;
		private var Speed_y:Number = 3;
		private var Direction:Number = -1;
		private var _TimePassed:Number = 0;
		private var _SniffCount:Number = 0;
		private var timeout:uint = 0;
		
		public var DogSprite:Spritemap = new Spritemap(DOG, 56, 48);
		
		public function Dog(animation:String)
		{
			this.layer = -1;
			DogSprite.scale = this.Scale;
			DogSprite.add( 'sniff', [0, 1], 4, true);
			DogSprite.add( 'walk', [1, 2, 3, 4], 8, true );
			DogSprite.add( 'yay_got_them', [5, 6, 7], 1, false );			
			DogSprite.add( 'got_one', [10], 1, true );
			DogSprite.add( 'got_both', [11], 1, true );
			DogSprite.add( 'laugh', [8, 9], 4, true );			
			graphic = DogSprite;
			DogSprite.play( animation );
			this.y = FP.screen.height * (2/3);			
		}
		
		override public function update():void
		{			
			_TimePassed += FP.elapsed;
			switch( DogSprite.currentAnim){
				case 'walk':					
					this.x += this.Speed;					
					if( _TimePassed >= 1.5 )
					{						
						_TimePassed = 0;
						DogSprite.play( 'sniff' );
					}
					break;
				case 'sniff':
					if( _TimePassed >= 0.8 )					
					{	
						_TimePassed = 0;						
						_SniffCount++;						
						
						if(_SniffCount == MAX_SNIFF_COUNT){
							DogSprite.play( 'yay_got_them' );
						}
						else
						{
							DogSprite.play( 'walk' );
						}
						
					}
						break;
				case 'yay_got_them':
					if(DogSprite.frame != 5)
					{
						this.y += this.Speed_y * Direction;
					}
					if( _TimePassed > 1.8)
					{
						_TimePassed = 0;
						if(DogSprite.frame == 7)
						{
							removeMeFromGame(true);							
						}
						
						layer = 1;		
						Direction = Direction * (-1);
					}
					break;
				case 'got_one':
					this.y+= this.Speed_y * this.Direction;
					if(_TimePassed >= 0.5 && Direction < 0)
					{
						Direction = 0;
						_TimePassed = 0;
					}
					if(_TimePassed >= 0.5 && Direction == 0)
					{
						Direction = 1;
						_TimePassed = 0;
					}
					if(_TimePassed >= 0.5 && Direction > 0)
					{
						removeMeFromGame(false);
					}
					
					break;
			}			
			
		}		
		
		private function removeMeFromGame(beggining:Boolean = false):void
		{
			var currentStage:MainStage = FP.world as MainStage;
			currentStage.remove(this);
			if(beggining){ currentStage.startGame();}
			else{ currentStage.addDuck();	}
		}
		
	}
}