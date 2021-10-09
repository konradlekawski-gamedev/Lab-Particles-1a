// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SwiftApps/AmplifyShader/Particles/ASE Particle Channels Additive"
{
	Properties
	{
		_MainTex("Particle Texture", 2D) = "white" {}
		_ColorStrR("Color R strength", Range( 0 , 10)) = 1
		_ColorStrG("Color G strength", Range( 0 , 10)) = 1
		_ColorStrB("Color B strength", Range( 0 , 10)) = 1
		_TintColorR("Tint Color R", Color) = (1,1,1,0)
		_TintColorG("Tint Color G", Color) = (1,1,1,0)
		_TintColorB("Tint Color B", Color) = (1,1,1,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" "PreviewType"="Plane" }
	LOD 0

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha One
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _TintColorR;
			uniform float _ColorStrR;
			uniform float4 _TintColorG;
			uniform float _ColorStrG;
			uniform float4 _TintColorB;
			uniform float _ColorStrB;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
#endif
				float2 uv0_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MainTex, uv0_MainTex );
				float3 ColorVert24 = (i.ase_color).rgb;
				float3 lerpResult23 = lerp( ColorVert24 , (_TintColorR).rgb , _TintColorR.a);
				float3 ColorR25 = ( lerpResult23 * _ColorStrR );
				float3 lerpResult29 = lerp( ColorVert24 , (_TintColorG).rgb , _TintColorG.a);
				float3 ColorG31 = ( lerpResult29 * _ColorStrG );
				float3 lerpResult33 = lerp( ColorVert24 , (_TintColorB).rgb , _TintColorB.a);
				float3 ColorB36 = ( lerpResult33 * _ColorStrB );
				float3 layeredBlendVar13 = (tex2DNode1).rgb;
				float3 layeredBlend13 = ( lerp( lerp( lerp( float3( 0,0,0 ) , ColorR25 , layeredBlendVar13.x ) , ColorG31 , layeredBlendVar13.y ) , ColorB36 , layeredBlendVar13.z ) );
				float AlphaVert38 = i.ase_color.a;
				float4 appendResult2 = (float4(layeredBlend13 , ( tex2DNode1.a * AlphaVert38 )));
				
				
				finalColor = appendResult2;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18101
13;23;1907;999;3465.456;-313.5622;1;True;True
Node;AmplifyShaderEditor.VertexColorNode;9;-3285.004,-139.11;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;21;-3027.958,-158.9565;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;17;-1981.65,-915.1317;Float;False;Property;_TintColorR;Tint Color R;4;0;Create;True;0;0;False;0;False;1,1,1,0;1,0.2469691,0,0.6980392;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-2746.035,-163.3605;Float;False;ColorVert;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;19;-1979.34,-549.8348;Float;False;Property;_TintColorG;Tint Color G;5;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-1972.741,-213.162;Float;False;Property;_TintColorB;Tint Color B;6;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;28;-1742.353,-550.8442;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-1753.227,-915.0366;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1736.442,-639.9282;Inherit;False;24;ColorVert;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1727.777,-305.0235;Inherit;False;24;ColorVert;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1739.659,-1010.342;Inherit;False;24;ColorVert;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;34;-1733.688,-215.9395;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;23;-1500.076,-933.9456;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1717.082,-20.83637;Float;False;Property;_ColorStrB;Color B strength;3;0;Create;False;0;0;False;0;False;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1605.666,-409.085;Float;False;Property;_ColorStrG;Color G strength;2;0;Create;False;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1599.804,-779.2437;Float;False;Property;_ColorStrR;Color R strength;1;0;Create;False;0;0;False;0;False;1;4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-1493.438,-566.9238;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;33;-1494.894,-235.4449;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1282.518,-566.1197;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-2563.956,742.5622;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1273.266,-934.7672;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1270.373,-231.3186;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-2240.018,716.5634;Inherit;True;Property;_MainTex;Particle Texture;0;0;Create;False;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-3028.353,-54.8496;Float;False;AlphaVert;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-1092.942,-237.0747;Float;False;ColorB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-1057.203,-937.6535;Float;False;ColorR;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1085.272,-571.0735;Float;False;ColorG;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1816.558,523.9684;Inherit;False;25;ColorR;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1816.824,598.6024;Inherit;False;31;ColorG;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1816.218,672.2079;Inherit;False;36;ColorB;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;14;-1875.995,116.191;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1889.11,890.8653;Inherit;False;38;AlphaVert;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1665.2,812.3416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;13;-1555.332,585.6097;Inherit;False;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;2;-1221.599,588.5821;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-973.0244,562.862;Float;False;True;-1;2;ASEMaterialInspector;0;1;SwiftApps/AmplifyShader/Particles/ASE Particle Channels Additive;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;8;5;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;4;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;IgnoreProjector=True;PreviewType=Plane;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;21;0;9;0
WireConnection;24;0;21;0
WireConnection;28;0;19;0
WireConnection;22;0;17;0
WireConnection;34;0;18;0
WireConnection;23;0;27;0
WireConnection;23;1;22;0
WireConnection;23;2;17;4
WireConnection;29;0;30;0
WireConnection;29;1;28;0
WireConnection;29;2;19;4
WireConnection;33;0;35;0
WireConnection;33;1;34;0
WireConnection;33;2;18;4
WireConnection;6;0;29;0
WireConnection;6;1;5;0
WireConnection;4;0;23;0
WireConnection;4;1;3;0
WireConnection;8;0;33;0
WireConnection;8;1;7;0
WireConnection;1;1;42;0
WireConnection;38;0;9;4
WireConnection;36;0;8;0
WireConnection;25;0;4;0
WireConnection;31;0;6;0
WireConnection;14;0;1;0
WireConnection;39;0;1;4
WireConnection;39;1;40;0
WireConnection;13;0;14;0
WireConnection;13;2;26;0
WireConnection;13;3;32;0
WireConnection;13;4;37;0
WireConnection;2;0;13;0
WireConnection;2;3;39;0
WireConnection;0;0;2;0
ASEEND*/
//CHKSM=E85D9F03725BF1882417D58D6D1368DAA2E3D51C