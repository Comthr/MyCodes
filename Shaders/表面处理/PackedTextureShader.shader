Shader "ShaderCaseStudy/Ch02/PackedTextureShader"
{
    Properties
    {
        _MainTint("Diffuse Tint",Color) = (1,1,1,1)
        _ColorA("Terrain Color A",Color) = (1,1,1,1)
        _ColorB("Terrain Color B",Color) = (1,1,1,1)
        _RTexture("Red Channel Texture",2D) = ""{}
        _GTexture("Green Channel Texture",2D) = ""{}
        _BTexture("Blue Channel Texture",2D) = ""{}
        _ATexture("Alpha Channel Texture",2D) = ""{}
        _BlendTex("Blend Texture",2D) = ""{}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        #pragma target 3.0

        struct Input
        {
            float2 uv_BlendTex;
        };

        float4 _MainTint;
        float4 _ColorA;
        float4 _ColorB;
        sampler2D _RTexture;
        sampler2D _GTexture;
        sampler2D _BTexture;
        sampler2D _ATexture;
        sampler2D _BlendTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 blendData = tex2D(_BlendTex,IN.uv_BlendTex);
            float4 rTexData = tex2D(_RTexture,IN.uv_BlendTex);
            float4 gTexData = tex2D(_GTexture,IN.uv_BlendTex);
            float4 bTexData = tex2D(_BTexture,IN.uv_BlendTex);
            float4 aTexData = tex2D(_ATexture,IN.uv_BlendTex);
            float4 fColor; 
            fColor = lerp(rTexData,gTexData,blendData.g);
            fColor = lerp(fColor,bTexData,blendData.b);
            fColor = lerp(fColor,aTexData,blendData.a);
            fColor.a = 1.0;
            float4 terrainLayers = lerp(_ColorA,_ColorB,blendData.r);
            fColor *= terrainLayers;
            fColor = saturate(fColor);
            o.Albedo = fColor*_MainTint.rgb;
            o.Alpha = fColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
