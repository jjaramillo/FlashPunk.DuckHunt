package co.FlashPunk.DuckHunt
{
	import co.FlashPunk.DuckHunt.Stages.MainStage;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class Game extends Engine
	{
		public function Game()
		{
			super(800, 600, 60, false);
			FP.world = new MainStage();
		}
	}
}