Shader "Custom/GrassWithWindRooted"
{
    Properties
    {
        _MainTex ("Grass Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (0.5, 1, 0.5, 1)
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
        _WindStrength ("Wind Strength", Range(0,1)) = 0.2
        _WindSpeed ("Wind Speed", Range(0,10)) = 2.0
        _WindScale ("Wind Scale", Range(0,10)) = 1.0
    }
    SubShader
    {
        Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert addshadow

        sampler2D _MainTex;
        fixed4 _Color;
        float _WindStrength;
        float _WindSpeed;
        float _WindScale;

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert (inout appdata_full v)
        {
            // World position for wind calculation
            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

            // Sine wave based on position + time
            float wave = sin(worldPos.x * _WindScale + _Time.y * _WindSpeed);

            // Factor based on vertex height (y). Bottom = 0, Top = 1
            float heightFactor = saturate(v.vertex.y);

            // Apply wind sway only to upper part
            v.vertex.x += wave * _WindStrength * heightFactor;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = tex.rgb;
            o.Alpha = tex.a;
        }
        ENDCG
    }
    FallBack "Transparent/Cutout/Diffuse"
}