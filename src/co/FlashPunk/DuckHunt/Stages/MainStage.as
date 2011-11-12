package co.FlashPunk.DuckHunt.Stages
{
	import co.FlashPunk.DuckHunt.Entities.Crosshair;
	import co.FlashPunk.DuckHunt.Entities.Dog;
	import co.FlashPunk.DuckHunt.Entities.Duck;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	public class MainStage extends World
	{
		[Embed(source = 'assets/sprites/background.png')]	
		private const BACKGROUND:Class;
		[Embed(source = 'assets/sprites/sky.png')]
		private const SKY:Class;
		
		private var background:Image = null;
		private var sky:Image = null;
		
		private var Scale:Number = 3;
		
		public function MainStage()
		{			
			background = new Image(BACKGROUND);
			sky = new Image(SKY);
			background.scale = this.Scale;
			sky.scale = this.Scale;
			
			addGraphic(sky, 2);
			addGraphic(background, 0);
			add(new Duck());
			add(new Crosshair());
		}
		
		
	}
}