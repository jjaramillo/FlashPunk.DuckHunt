package co.FlashPunk.DuckHunt.Entities
{
	import co.FlashPunk.DuckHunt.Stages.MainStage;
	import co.FlashPunk.DuckHunt.Util.MathUtil;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.sampler.startSampling;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Screen;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	public class Duck extends Entity
	{
		[Embed(source = 'assets/sprites/duck.png')]
		private const DUCK:Class;
		//[Embed(source = 'assets/sounds/Duck_Hitting_the_Ground.mp3')]
		//private const HIT_GROUND:Class;
		private const MAX_WAIT_TIME_AFTER_BEING_SHOOT:Number = 1;
		private const FALLING_SPEED:Number = 3.5;
		private const ALIVE:String = 'Alive';
		private const DEAD:String = 'Dead';
		private const JUST_SHOOT:String = 'Just Shoot';
		
		private static var SPRITEWIDTH:Number = 34;
		private static var SPRITEHEIGHT:Number = 33;		
		
		private var Scale:Number = 2;
		private var Speed:Number = 2;
		private var Speed_y:Number = 2;
		private var _TimePassed:Number = 0;
		private var _Angle:Number = 0;
		private var _Starting_x:Number = 0;
		private var _Starting_y:Number = 0;
		private var _Direction_x:Number = 1;
		private var _Direction_y:Number = 1;		
		private var _SecondsAfterBeingShoot:Number = 0;
		
		private var _Status:String = 'Alive';
		
		private var DuckSprite:Spritemap = new Spritemap(DUCK, SPRITEWIDTH, SPRITEHEIGHT);
		//private var HitGroundSound:Sfx = new Sfx(HIT_GROUND);
		
		public function Duck()
		{		
			
			DuckSprite.scale = this.Scale;
			DuckSprite.add( 'fly_up', [0, 1, 2, 1], 8, true );
			DuckSprite.add( 'fly_side', [7, 6, 8, 6], 8, true );			
			DuckSprite.add( 'fall', [4, 5], 4, true );
			DuckSprite.add( 'got_hit', [3], 1, false );
			graphic = DuckSprite;
			DuckSprite.play( 'fly_up' );
			
			this._Angle = MathUtil.randomNumber(10, 170);		
			
			this.x = (FP.screen.width / 2) - (SPRITEWIDTH * this.Scale) / 2;
			this.y = FP.screen.height - (SPRITEHEIGHT * this.Scale*2) - 138;
			
			_Starting_x = this.x;
			_Starting_y = this.y;
			this.layer = 1;
			recalculateSpeed_y();
			
			var randomStart:Number = MathUtil.randomNumber(-1, 1);
			this._Direction_x = randomStart > 0 ? 1 : -1;
			
			DuckSprite.flipped = randomStart > 0 ? false: true;
			
			setHitbox(SPRITEWIDTH * this.Scale, 
				SPRITEHEIGHT * this.Scale);
		}
		
		override public function update():void
		{
			switch(_Status){
				case ALIVE:
					this.x += this.Speed * _Direction_x;
					this.y += this.Speed_y * _Direction_y;
					checkHit();
					checkStageLimits();
				break;
				case DEAD:					
					this.y += FALLING_SPEED;
					if(this.y > _Starting_y + (SPRITEHEIGHT * this.Scale))
					{
						removeMeFromGame();
					}
				break;
				case JUST_SHOOT:
					_SecondsAfterBeingShoot+=FP.elapsed;
					if(_SecondsAfterBeingShoot > MAX_WAIT_TIME_AFTER_BEING_SHOOT)
					{
						_Status = DEAD;
						this.Speed_y = 2;
						DuckSprite.play('fall');
					}
				break;
			}		
		}
		
		private function checkStageLimits():void
		{
			if(this.x + (SPRITEWIDTH * this.Scale) >= FP.screen.width)
			{				
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				DuckSprite.flipped = true;
				this._Direction_x = this._Direction_x * (-1);
				this.x = FP.screen.width - (SPRITEWIDTH * this.Scale);
				
			}
			if(this.x <= 0)
			{				
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				DuckSprite.flipped = false;
				this._Direction_x = this._Direction_x * (-1);
				this.x = 0;
			}
			if(this.y <=0 )
			{
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				this._Direction_y = this._Direction_y * (-1);
				this.y = 0;
			}
			if(this.y  > _Starting_y)
			{
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				this._Direction_y = this._Direction_y * (-1);
				this. y = _Starting_y;
			}			
		}
		
		private function recalculateSpeed_y():void
		{
			var firstPoint:Number =  _Starting_y - ( this.x + (this.Speed * this._Direction_x) - _Starting_x) * Math.sin((this._Angle*(Math.PI/180)));
			var secondPoint:Number =  _Starting_y - ( this.x + 2*(this.Speed * this._Direction_x) - _Starting_x) * Math.sin((this._Angle*(Math.PI/180)));
			this.Speed_y =secondPoint - firstPoint;
		}
		
		private function checkHit():void
		{			
			var crossHair:Crosshair = collide('Crosshair', x, y) as Crosshair;
			if(crossHair && Input.mousePressed)
			{
				_Status = JUST_SHOOT;
				DuckSprite.play('got_hit');
			}
		}
	
		private function removeMeFromGame():void
		{
			//HitGroundSound.play();
			var currentStage:MainStage = FP.world as MainStage;
			currentStage.remove(this);
			currentStage.showDogWithDuck(this.x, this.y);
		}
	}
}