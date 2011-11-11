package co.FlashPunk.DuckHunt.Entities
{
	import co.FlashPunk.DuckHunt.Util.MathUtil;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Screen;
	import net.flashpunk.graphics.Spritemap;
	
	public class Duck extends Entity
	{
		[Embed(source = 'assets/sprites/duck.png')]
		private const DUCK:Class;
		private static var SPRITEWIDTH:Number = 34;
		private static var SPRITEHEIGHT:Number = 33;
		
		
		private var Scale:Number = 2;
		private var Speed:Number = 1;
		private var Speed_y:Number = 1;
		private var _TimePassed:Number = 0;
		private var _Angle:Number = 0;
		private var _Starting_x:Number = 0;
		private var _Starting_y:Number = 0;
		private var _Direction_x:Number = 1;
		private var _Direction_y:Number = 1;
		
		public var DuckSprite:Spritemap = new Spritemap(DUCK, SPRITEWIDTH, SPRITEHEIGHT);
		
		public function Duck()
		{
			DuckSprite.scale = this.Scale;
			DuckSprite.add( 'fly_up', [0, 1, 2, 1], 8, true );
			DuckSprite.add( 'fly_side', [7, 6, 8, 6], 8, true );			
			DuckSprite.add( 'fall', [4, 5], 2, true );
			DuckSprite.add( 'got_hit', [3], 1, false );
			graphic = DuckSprite;
			DuckSprite.play( 'fly_up' );
			
			this._Angle = MathUtil.randomNumber(10, 170);		
			
			this.x = (FP.screen.width / 2) - (SPRITEWIDTH * this.Scale) / 2;
			this.y = FP.screen.height - (SPRITEHEIGHT * this.Scale*2);
			
			_Starting_x = this.x;
			_Starting_y = this.y;
			
			recalculateSpeed_y();
			var randomStart:Number = 1;//MathUtil.randomNumber(-1, 1) >0? 1: -1;
			this._Direction_x = randomStart > 0 ? 1 : -1;
			DuckSprite.flipped = randomStart > 0 ? false: true;
		}
		
		override public function update():void
		{
			
			this.x += this.Speed * _Direction_x;
			this.y += this.Speed_y;
			
			checkStageLimits();	
		}
		
		private function checkStageLimits():void
		{
			if(this.x + (SPRITEWIDTH * this.Scale) >= FP.screen.width)
			{				
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				DuckSprite.flipped = true;
				this._Direction_x = this._Direction_x * (-1);
				
			}
			if(this.x <= 0)
			{				
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				DuckSprite.flipped = false;
				this._Direction_x = this._Direction_x * (-1);
			}
			if(this.y <=0 )
			{
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				this._Direction_y = this._Direction_y * (-1);	
			}
			if(this.y + (SPRITEHEIGHT * this.Scale)  >= FP.screen.height)
			{
				this._Angle = MathUtil.randomNumber(10, 80);
				recalculateSpeed_y();
				this._Direction_y = this._Direction_y * (-1);
			}			
		}
		
		private function recalculateSpeed_y():void
		{
			var firstPoint:Number =  _Starting_y - ( this.x + (this.Speed * this._Direction_x) - _Starting_x) * Math.sin((this._Angle*(Math.PI/180)));
			var secondPoint:Number =  _Starting_y - ( this.x + 2*(this.Speed * this._Direction_x) - _Starting_x) * Math.sin((this._Angle*(Math.PI/180)));
			this.Speed_y = secondPoint - firstPoint;
		}
	}
}