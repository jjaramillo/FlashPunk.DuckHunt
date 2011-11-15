package co.FlashPunk.DuckHunt.Entities
{
	import co.FlashPunk.DuckHunt.Stages.MainStage;
	import co.FlashPunk.DuckHunt.Util.MathUtil;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.sampler.startSampling;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
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
		
		[Embed(source = 'assets/sounds/duck_hits_ground.mp3')]
		private const HIT_GROUND:Class;		
		[Embed(source = 'assets/sounds/wing_flap.mp3')]
		private const WING_FLAP:Class;
		[Embed(source = 'assets/sounds/duck_falling.mp3')]
		private const DUCK_FALLING:Class;
		[Embed(source = 'assets/sounds/duck.mp3')]
		private const DUCK_SOUND:Class;		
		
		
		private const MAX_WAIT_TIME_AFTER_BEING_SHOOT:Number = 1;
		private const FALLING_SPEED:Number = 3.5;
		private const ALIVE:String = 'Alive';
		private const DEAD:String = 'Dead';
		private const JUST_SHOOT:String = 'Just Shoot';
		private const GOT_AWAY:String = 'Got Away';
		private const MAX_TIME_FLYING:Number = 8;
		private const GOT_AWAY_SPEED:Number = -5;
		
		public static var SPRITEWIDTH:Number = 34;
		public static var SPRITEHEIGHT:Number = 33;		
		
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
		private var _SecondsFlying:Number = 0;
		
		private var _Status:String = 'Alive';
		
		private var DuckSprite:Spritemap = new Spritemap(DUCK, SPRITEWIDTH, SPRITEHEIGHT);
		
		private var HitGroundSound:Sfx = new Sfx(HIT_GROUND);
		private var WingFlapSound:Sfx = new Sfx(WING_FLAP);
		private var DuckFallingSound:Sfx = new Sfx(DUCK_FALLING);
		private var DuckSound:Sfx = new Sfx(DUCK_SOUND);		
		
		private var DuckSoundInterval:uint = 0;
		private var DuckDirectionInterval:uint = 0;
		
		public function Duck()
		{			 
			DuckSoundInterval = setInterval(
				function():void
				{
					DuckSound.play();
				},1000);
			
			DuckDirectionInterval = setInterval(
				function():void
				{
					var random_x_direction:Number = MathUtil.randomNumber(-1, 1);
					var random_y_direction:Number = MathUtil.randomNumber(-1, 1);
					_Direction_x = random_x_direction > 0 ? 1 : -1;					
					_Direction_y = random_y_direction > 0 ? 1 : -1;
					this._Angle = MathUtil.randomNumber(0, 180);
					recalculateSpeed_y();
					if(_Direction_x > 0){ DuckSprite.flipped = false; }
					else { DuckSprite.flipped = true; }
					if(
						(this._Angle > 0 && this._Angle < 30)
						|| (this._Angle > 150 && this._Angle < 180)
					) { DuckSprite.play( 'fly_side' ); }
					else { DuckSprite.play( 'fly_up' ); }
				},1000);
				
			
			Speed = MathUtil.randomNumber(2, 8);
			DuckSprite.scale = this.Scale;
			DuckSprite.add( 'fly_up', [0, 1, 2, 1], 8, true );
			DuckSprite.add( 'fly_side', [7, 6, 8, 6], 8, true );			
			DuckSprite.add( 'fall', [4, 5], 4, true );
			DuckSprite.add( 'got_hit', [3], 1, false );
			graphic = DuckSprite;
			DuckSprite.play( 'fly_up' );
			DuckSound.play();
			
			this._Angle = MathUtil.randomNumber(10, 170);		
			
			this.x = MathUtil.randomNumber(SPRITEWIDTH * this.Scale, FP.screen.width - (SPRITEWIDTH * this.Scale));
				(FP.screen.width / 2) - (SPRITEWIDTH * this.Scale) / 2;
			this.y = FP.screen.height - (SPRITEHEIGHT * this.Scale*2) - 138;
			
			_Starting_x = this.x;
			_Starting_y = this.y;
			
			this.layer = 1;
			recalculateSpeed_y();
			
			var randomStart:Number = MathUtil.randomNumber(-1, 1);
			this._Direction_x = randomStart > 0 ? 1 : -1;
			
			DuckSprite.flipped = randomStart > 0 ? false: true;
			
			var hitBoxWidth:Number = SPRITEWIDTH * (this.Scale / 2);
			var hitBoxHeight:Number = SPRITEHEIGHT * (this.Scale / 2);
			var hitBoxCenter_x:Number = SPRITEWIDTH * (this.Scale / 2) - (hitBoxWidth /2 );
			var hitBoxCenter_y:Number = SPRITEHEIGHT * (this.Scale / 2) - (hitBoxHeight / 2)
			
			//setHitbox(hitBoxWidth, hitBoxHeight, hitBoxCenter_x, hitBoxCenter_y);
			setHitbox(SPRITEWIDTH, SPRITEHEIGHT);
			trace('CH:'+ hitBoxCenter_x + ' CV: ' + hitBoxCenter_y)
			WingFlapSound.loop();;
		}
		
		override public function update():void
		{
			switch(_Status){
				case ALIVE:
					this.x += this.Speed * _Direction_x;
					this.y += this.Speed_y * _Direction_y;
					checkHit();
					checkStageLimits();
					checkFlyingTime();
				break;
				case DEAD:				
					this.y += FALLING_SPEED;
					if(this.y > _Starting_y + (SPRITEHEIGHT * this.Scale))
					{
						DuckFallingSound.stop();
						HitGroundSound.play();
						removeMeFromGame();
					}
				break;
				case JUST_SHOOT:
					DuckSound.stop();
					clearInterval(DuckSoundInterval);
					WingFlapSound.stop();
					_SecondsAfterBeingShoot+=FP.elapsed;
					if(_SecondsAfterBeingShoot > MAX_WAIT_TIME_AFTER_BEING_SHOOT)
					{
						_Status = DEAD;
						this.Speed_y = 2;
						DuckSprite.play('fall');
						DuckFallingSound.play();
					}
				break;
				case GOT_AWAY:					
					this.y += GOT_AWAY_SPEED;
					if(this.y + SPRITEHEIGHT * this.Scale < 0)
					{
						escapeAndRemove();
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
			if(crossHair && _Status == ALIVE) 
			{
				if(Input.mousePressed){
					_Status = JUST_SHOOT;
					DuckSprite.play('got_hit');
					clearInterval(DuckDirectionInterval);
				}
			}
		}
	
		private function removeMeFromGame():void
		{
			var currentStage:MainStage = FP.world as MainStage;
			currentStage.remove(this);
			currentStage.TryToShowDog(this.x, this.y, true);
		}
		
		public function gotAway():void
		{		
			clearInterval(DuckDirectionInterval);
			DuckSprite.play( 'fly_up' );
			this.Speed = 0;
			this._Status = GOT_AWAY;
			var currentStage:MainStage = FP.world as MainStage;
			currentStage.sky.changeSky( 'red' );
		}
		
		public function escapeAndRemove():void
		{
			DuckSound.stop();
			clearInterval(DuckSoundInterval);
			WingFlapSound.stop();
			var currentStage:MainStage = FP.world as MainStage;
			currentStage.remove(this);
			currentStage.TryToShowDog(this.x, this.y = FP.screen.height * (2/3), false);
		}
	
		private function checkFlyingTime():void
		{
			this._SecondsFlying += FP.elapsed;
			if(this._SecondsFlying > MAX_TIME_FLYING)
			{
				gotAway();
			}
		}
	}
}