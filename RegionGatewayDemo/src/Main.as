package {
	import org.osmf.utils.FMSURL;
	import org.osmf.layout.RegistrationPoint;
	import org.osmf.display.ScaleMode;
	import org.osmf.utils.URL;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.video.VideoElement;
	import org.osmf.composition.ParallelElement;
	import org.osmf.gateways.RegionGateway;
	import org.osmf.layout.LayoutUtils;
	import org.osmf.media.MediaPlayer;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author flo
	 */
	public class Main extends Sprite {
		
		private var mediaPlayer:MediaPlayer = new MediaPlayer();
		
		private var mainRegion : RegionGateway = new RegionGateway();
		private var leftChildRegion : RegionGateway = new RegionGateway();
		private var rightChildRegion : RegionGateway = new RegionGateway();
		
		private var parallelComposition:ParallelElement = new ParallelElement();		
		
		public function Main() {
			
			setupStage();
			
			setupMainRegion();
			setupLeftRegion();
			setupRightRegion();
					
			mainRegion.addChildRegion(leftChildRegion);
			mainRegion.addChildRegion(rightChildRegion);
			
			addChild(mainRegion);			
			
			var mainVidElement:VideoElement = getMainVideoElement();
			var leftVidElement:VideoElement = getLeftVideoElement();
			
			// set width and height to 100 per cent
			// display as a centered letterbox			
			LayoutUtils.setRelativeLayout(mainVidElement.metadata, 100, 100 );
			LayoutUtils.setRelativeLayout(leftVidElement.metadata, 100, 100 );
			LayoutUtils.setLayoutAttributes(mainVidElement.metadata, ScaleMode.LETTERBOX, RegistrationPoint.CENTER);
			LayoutUtils.setLayoutAttributes(leftVidElement.metadata, ScaleMode.LETTERBOX, RegistrationPoint.CENTER);
			
			// wire video element with region    		
			mainVidElement.gateway = mainRegion;
			leftVidElement.gateway = leftChildRegion;
						
			// add both videos to a parallel composition			
			parallelComposition.addChild(mainVidElement);
			parallelComposition.addChild(leftVidElement);			
						
			// play composition			
			mediaPlayer.element = parallelComposition;
		}

		private function setupMainRegion():void {
	 
			// color and alpha
			mainRegion.backgroundColor = 0xf7f6af;
			mainRegion.backgroundAlpha = 0.5;
			
			// set to 640x480 pixels
			LayoutUtils.setAbsoluteLayout(mainRegion.metadata, 640, 480);
		
		}
		
		private function setupLeftRegion():void {
			// color and alpha
			leftChildRegion.backgroundColor = 0x9bd6a3;    
			leftChildRegion.backgroundAlpha = 1;
			// left=10, top=10, right=flexible, bottom=10 
			LayoutUtils.setAnchorLayout(leftChildRegion.metadata, 10, 10, NaN, 10);
			// width=100 pixels, height=250
			LayoutUtils.setAbsoluteLayout(leftChildRegion.metadata, 250, 250 ); 
		
		}
		
		private function setupRightRegion():void {
			// color and alpha
			rightChildRegion.backgroundColor = 0x4e8264;
			rightChildRegion.backgroundAlpha = 1;	
			// left=flexible, top=10, right=10, bottom=10				
			LayoutUtils.setAnchorLayout(rightChildRegion.metadata, NaN, 10, 10, 10);
			// width=100 pixels, height=flexible
			LayoutUtils.setAbsoluteLayout(rightChildRegion.metadata, 100, NaN );			
		}
		
		private function getMainVideoElement():VideoElement {
			return new VideoElement(new NetLoader(), new URLResource(new URL("http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv")));
		}
		
		private function getLeftVideoElement():VideoElement {
			return new VideoElement(new NetLoader(), new URLResource(new FMSURL("rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short")));
		}

		private function setupStage():void {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;   
		}
		
		
	}
}
